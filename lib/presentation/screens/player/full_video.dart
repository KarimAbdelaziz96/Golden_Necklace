part of '../screens.dart';

class FullVideoScreen extends StatefulWidget {
  const FullVideoScreen({
    Key? key,
    required this.link,
    required this.title,
    this.isLive = false,
  }) : super(key: key);
  final String link;
  final String title;
  final bool isLive;

  @override
  State<FullVideoScreen> createState() => _FullVideoScreenState();
}

class _FullVideoScreenState extends State<FullVideoScreen> {
  late VlcPlayerController _videoPlayerController;
  // CastSessionManager? _castSessionManager;
  CastSession? _castSession;

  bool isPlayed = true;
  bool progress = true;
  bool showControllersVideo = true;
  String position = '';
  String duration = '';
  double sliderValue = 0.0;
  bool validPosition = false;
  double _currentVolume = 0.0;
  double _currentBright = 0.0;
  late Timer timer;

  @override
  void initState() {
 

    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    Wakelock.enable();

    _videoPlayerController = VlcPlayerController.network(widget.link,
        hwAcc: HwAcc.auto,
        autoPlay: true,
        autoInitialize: true,
        options: VlcPlayerOptions(
            extras: [
              '--no-plugins-cache',
              '--no-skip-frames',
            ],
            audio: VlcAudioOptions([
              '--audio-sync',
              '--volume=100', // تعيين مستوى الصوت الافتراضي إلى 100%
              '--no-metadata-cache', // إيقاف ذاكرة التخزين المؤقت للبيانات الوصفية
              '--audio-filter=abuffer',
            ]),
            http: VlcHttpOptions([
              '--http-caching=1000', // تعيين حجم التخزين المؤقت HTTP إلى 1000 ميلي ثانية
              '--http-reconnect', // تمكين إعادة الاتصال عبر HTTP
              '--http-timeout=5000', // تعيين مهلة الاتصال HTTP إلى 5000 ميلي ثانية
              '--http-user-agent=YourAppName/1.0', // تعيين وكيل المستخدم
            ]),
            video: VlcVideoOptions([
              '--video-x=0', // تعيين موقع الفيديو على المحور X
              '--video-y=0', // تعيين موقع الفيديو على المحور Y
              '--video-scale=1.0', // تعيين مقياس العرض إلى 1.0
              '--no-video-deco', // تعطيل زخرفة الفيديو (مفيد لتحسين الأداء)
              '--no-video-filter', // تعطيل الفلاتر لتقليل المعالجة
            ]),
            sout: VlcStreamOutputOptions([
              '--sout=#rtp{sdp=rtsp://@:8554/stream}', // إعداد البث عبر RTP
              '--sout-all', // تفعيل بث جميع المسارات
              '--sout-video-filter', // تطبيق فلتر الفيديو للبث
              '--sout-audio-filter', // تطبيق فلتر الصوت للبث
              '--sout-mux-caching=3000', // تعيين حجم التخزين المؤقت لمزج البث إلى 3000 ميلي ثانية
            ])));

    _videoPlayerController.addListener(listener);
    _settingPage();

    timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (showControllersVideo) {
        setState(() {
          showControllersVideo = false;
        });
      }
    });
  }

  String _getContentType(String url) {
    final extension = url.split('.').last.split('?').first.toLowerCase();
    switch (extension) {
      case 'mp4':
        return 'video/mp4';
      case 'webm':
        return 'video/webm';
      case 'mkv':
        return 'video/x-matroska';
      case 'avi':
        return 'video/x-msvideo';
      case 'mov':
        return 'video/quicktime';
      default:
        return 'application/octet-stream'; // نوع محتوى افتراضي للملفات غير المعروفة
    }
  }

  Future<void> _startCasting() async {
    try {
      final List<CastDevice> devices = await CastDiscoveryService().search();
      if (devices.isNotEmpty) {
        final CastDevice device = devices.first;
        _castSession = await CastSessionManager().startSession(device);
        _castSession?.stateStream.listen((state) {
          if (state == CastSessionState.connected) {
            final snackBar =
                SnackBar(content: Text('Connected to ${device.name}'));
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
            _sendMessagePlayVideo();
          }
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('No Chromecast devices found')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Casting failed: $e')));
    }
  }

  void _sendMessagePlayVideo() {
    if (_castSession != null) {
      final contentType = _getContentType(widget.link);

      final message = {
        'contentId': widget.link,
        'contentType': contentType,
        'streamType': 'BUFFERED',
        'metadata': {
          'type': 0,
          'metadataType': 0,
          'title': widget.title,
        },
      };

      _castSession!.sendMessage(CastSession.kNamespaceMedia, {
        'type': 'LOAD',
        'autoPlay': true,
        'currentTime': 0,
        'media': message,
      });
    }
  }

  @override
  void dispose() async {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);
    super.dispose();
    await _videoPlayerController.stopRendererScanning();
    await _videoPlayerController.dispose();
    timer.cancel();
  }

  void listener() async {
    if (!mounted) return;

    if (progress) {
      if (_videoPlayerController.value.isPlaying) {
        setState(() {
          progress = false;
        });
      }
    }

    if (_videoPlayerController.value.isInitialized) {
      var oPosition = _videoPlayerController.value.position;
      var oDuration = _videoPlayerController.value.duration;

      if (oDuration.inHours == 0) {
        var strPosition = oPosition.toString().split('.')[0];
        var strDuration = oDuration.toString().split('.')[0];
        position = "${strPosition.split(':')[1]}:${strPosition.split(':')[2]}";
        duration = "${strDuration.split(':')[1]}:${strDuration.split(':')[2]}";
      } else {
        position = oPosition.toString().split('.')[0];
        duration = oDuration.toString().split('.')[0];
      }
      validPosition = oDuration.compareTo(oPosition) >= 0;
      sliderValue = validPosition ? oPosition.inSeconds.toDouble() : 0;
      setState(() {});
    }
  }

  void _onSliderPositionChanged(double progress) {
    setState(() {
      sliderValue = progress.floor().toDouble();
    });
    _videoPlayerController.setTime(sliderValue.toInt() * 1000);
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("SIZE: ${MediaQuery.of(context).size.width}");
    return WillPopScope(
      onWillPop: () async {
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp,
          DeviceOrientation.portraitDown,
        ]);
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              color: Colors.black,
              child: VlcPlayer(
                controller: _videoPlayerController,
                aspectRatio: 16 / 9,
                virtualDisplay: true,
                placeholder: const SizedBox(),
              ),
            ),
            if (progress)
              const Center(
                child: CircularProgressIndicator(
                  color: Colors.red,
                ),
              ),
            GestureDetector(
              onTap: () {
                setState(() {
                  showControllersVideo = !showControllersVideo;
                });
              },
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                color: Colors.transparent,
                child: AnimatedSize(
                  duration: const Duration(milliseconds: 200),
                  child: !showControllersVideo
                      ? const SizedBox()
                      : SafeArea(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  IconButton(
                                    onPressed: () async {
                                      await Future.delayed(const Duration(
                                              milliseconds: 1000))
                                          .then((value) {
                                        Get.back(
                                            result: progress
                                                ? null
                                                : [
                                                    sliderValue,
                                                    _videoPlayerController.value
                                                        .duration.inSeconds
                                                        .toDouble()
                                                  ]);
                                      });
                                    },
                                    icon: Icon(
                                      FontAwesomeIcons.chevronLeft,
                                      size: 19.sp,
                                    ),
                                  ),
                                  const SizedBox(width: 5),
                                  Expanded(
                                    child: Text(
                                      widget.title,
                                      maxLines: 1,
                                      style: Get.textTheme.labelLarge!.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18.sp,
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      _startCasting();
                                    },
                                    icon: Icon(
                                      FontAwesomeIcons.chromecast,
                                      size: 24.sp,
                                    ),
                                  ),
                                ],
                              ),
                              if (!progress && !widget.isLive)
                                Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Slider(
                                          activeColor: Colors.red,
                                          inactiveColor: Colors.white,
                                          value: sliderValue,
                                          min: 0.0,
                                          max: (!validPosition)
                                              ? 1.0
                                              : _videoPlayerController
                                                  .value.duration.inSeconds
                                                  .toDouble(),
                                          onChanged: validPosition
                                              ? _onSliderPositionChanged
                                              : null,
                                        ),
                                      ),
                                      Text(
                                        "$position / $duration",
                                        style:
                                            Get.textTheme.titleSmall!.copyWith(
                                          fontSize: 15.sp,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        ),
                ),
              ),
            ),
            if (!progress && showControllersVideo)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  if (!isTv(context))
                    FillingSlider(
                      direction: FillingSliderDirection.vertical,
                      initialValue: _currentVolume,
                      onFinish: (value) async {
                        try {
                       PerfectVolumeControl.hideUI = true;
                        await PerfectVolumeControl.setVolume(value);
                          setState(() {
                            _currentBright = value;
                          });
                        } catch (e) {
                          print('Error setting brightness: $e');
                        }
                      },
                      fillColor: Colors.white54,
                      height: 40.h,
                      width: 30,
                      child: Icon(
                        _currentVolume < .1
                            ? FontAwesomeIcons.volumeXmark
                            : _currentVolume < .7
                                ? FontAwesomeIcons.volumeLow
                                : FontAwesomeIcons.volumeHigh,
                        color: Colors.black,
                        size: 13,
                      ),
                    ),
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (!widget.isLive)
                          IconButton(
                            onPressed: () {
                              _videoPlayerController.seekTo(
                                _videoPlayerController.value.position -
                                    const Duration(seconds: 10),
                              );
                            },
                            icon: Icon(
                              Icons.replay_10,
                              size: 20.sp,
                            ),
                          ),
                        const SizedBox(
                          width: 20,
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              if (isPlayed) {
                                _videoPlayerController.pause();
                                isPlayed = false;
                              } else {
                                _videoPlayerController.play();
                                isPlayed = true;
                              }
                            });
                          },
                          icon: Icon(
                            isPlayed
                                ? FontAwesomeIcons.pause
                                : FontAwesomeIcons.play,
                            size: 24.sp,
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        if (!widget.isLive)
                          IconButton(
                            onPressed: () {
                              _videoPlayerController.seekTo(
                                _videoPlayerController.value.position +
                                    const Duration(seconds: 10),
                              );
                            },
                            icon: Icon(
                              Icons.forward_10,
                              size: 20.sp,
                            ),
                          ),
                      ],
                    ),
                  ),
                  if (!isTv(context))
                    FillingSlider(
                      initialValue: _currentBright,
                      direction: FillingSliderDirection.vertical,
                      fillColor: Colors.white54,
                      height: 40.h,
                      width: 30,
                      onFinish: (value) async {
                        try{

       await ScreenBrightness().setScreenBrightness(value);
                        setState(() {
                          _currentBright = value;
                        });

                        }catch(e){
                          print('Error setting brightness: $e');

                        }
                 
                      },
                      child: Icon(
                        FontAwesomeIcons.solidSun,
                        color: Colors.black,
                        size: 13,
                      ),
                    ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _settingPage() async {
    try {
      _currentBright = await ScreenBrightness().current;
      _currentVolume = await PerfectVolumeControl.volume;

      setState(() {});
    } catch (e) {
      debugPrint("Error: setting: $e");
    }
  }
}
