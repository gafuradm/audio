import UIKit
import SnapKit
import AVFoundation
class ViewController: UIViewController {
    var audioRecorder: AVAudioRecorder?
    var audioPlayer: AVAudioPlayer?
    var audioURL: URL?
    let recordButton = UIButton()
    let playButton = UIButton()
    var isRecording = false
    var isPlaying = false
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        recordButton.backgroundColor = .systemPink
        recordButton.layer.cornerRadius = 60
        recordButton.setTitleColor(.white, for: .normal)
        recordButton.setTitle("Запись", for: .normal)
        recordButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 19)
        recordButton.addTarget(self, action: #selector(toggleRecording), for: .touchUpInside)
        view.addSubview(recordButton)
        recordButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(-50)
            $0.width.height.equalTo(120)
        }
        playButton.backgroundColor = .systemBlue
        playButton.layer.cornerRadius = 60
        playButton.setTitleColor(.white, for: .normal)
        playButton.setTitle("Прослушать", for: .normal)
        playButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        playButton.addTarget(self, action: #selector(togglePlaying), for: .touchUpInside)
        view.addSubview(playButton)
        playButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(125)
            $0.width.height.equalTo(120)
        }
        let audioSettings: [String: Any] = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue,
            AVEncoderBitRateKey: 320000,
            AVNumberOfChannelsKey: 2,
            AVSampleRateKey: 44100.0
        ]
        do {
            audioRecorder = try AVAudioRecorder(url: getDocumentsDirectory().appendingPathComponent("audio.m4a"), settings: audioSettings)
            audioRecorder?.prepareToRecord()
        } catch {
            print("Ошибка при настройке аудиозаписи: \(error.localizedDescription)")
        }
    }
    @objc func toggleRecording() {
        if isRecording {
            audioRecorder?.stop()
            recordButton.setTitle("Запись", for: .normal)
        } else {
            audioURL = getDocumentsDirectory().appendingPathComponent("audio.m4a")
            audioRecorder?.record()
            recordButton.setTitle("Остановить", for: .normal)
        }
        animateButton(recordButton, isRecording)
        isRecording.toggle()
    }
    @objc func togglePlaying() {
        if isPlaying {
            audioPlayer?.stop()
            playButton.setTitle("Прослушать", for: .normal)
        } else {
            if let audioURL = audioURL {
                do {
                    audioPlayer = try AVAudioPlayer(contentsOf: audioURL)
                    audioPlayer?.play()
                    playButton.setTitle("Стоп", for: .normal)
                } catch {
                    print("Ошибка при воспроизведении аудио: \(error.localizedDescription)")
                }
            } else {
                print("Аудио еще не записано.")
            }
        }
        animateButton(playButton, isPlaying)
        isPlaying.toggle()
    }
    func animateButton(_ button: UIButton, _ isAnimating: Bool) {
        let scale: CGFloat = isAnimating ? 1.0 : 1.2
        UIView.animate(withDuration: 0.3) {
            button.transform = CGAffineTransform(scaleX: scale, y: scale)
        }
    }
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths.first!
    }
}
