import UIKit
import Hue
import AVKit
import AVFoundation
import Imaginary

public class LightboxConfig {
  /// Whether to show status bar while Lightbox is presented
  public static var hideStatusBar = true

  /// Provide a closure to handle selected video
  public static var handleVideo: (_ from: UIViewController, _ videoURL: URL) -> Void = { from, videoURL in
    let videoController = AVPlayerViewController()
    videoController.player = AVPlayer(url: videoURL)

    from.present(videoController, animated: true) {
      videoController.player?.play()
    }
  }

  /// How to load image onto UIImageView
  public static var loadImage: (UIImageView, URL, ((UIImage?) -> Void)?) -> Void = { (imageView, imageURL, completion) in

    // Use Imaginary by default
    imageView.setImage(url: imageURL, placeholder: nil, completion: { result in
      switch result {
      case .value(let image):
        completion?(image)
      case .error:
        completion?(nil)
      }
    })
  }

  /// Indicator is used to show while image is being fetched
  public static var makeLoadingIndicator: () -> UIView = {
    return LoadingIndicator()
  }

  public struct PageIndicator {
    public static var enabled = true
    public static var separatorColor = UIColor(hex: "3D4757")

    public static var textAttributes: [String: Any] = [
      NSFontAttributeName: UIFont.systemFont(ofSize: 12),
      NSForegroundColorAttributeName: UIColor(hex: "899AB8"),
      NSParagraphStyleAttributeName: {
        var style = NSMutableParagraphStyle()
        style.alignment = .center
        return style
      }()
    ]
  }

  public struct CloseButton {
    public static var enabled = true
    public static var size: CGSize?
    public static var text = NSLocalizedString("Close", comment: "")
    public static var image: UIImage?

    public static var textAttributes: [String: Any] = [
        NSFontAttributeName: UIFont.boldSystemFont(ofSize: 16),
      NSForegroundColorAttributeName: UIColor.white,
      NSParagraphStyleAttributeName: {
        var style = NSMutableParagraphStyle()
        style.alignment = .center
        return style
      }()
    ]
  }

  public struct DeleteButton {
    public static var enabled = false
    public static var size: CGSize?
    public static var text = NSLocalizedString("Delete", comment: "")
    public static var image: UIImage?

    public static var textAttributes: [String: Any] = [
      NSFontAttributeName: UIFont.boldSystemFont(ofSize: 16),
      NSForegroundColorAttributeName: UIColor(hex: "FA2F5B"),
      NSParagraphStyleAttributeName: {
        var style = NSMutableParagraphStyle()
        style.alignment = .center
        return style
      }()
    ]
  }

  public struct InfoLabel {
    public static var enabled = true
    public static var textColor = UIColor.white
    public static var ellipsisText = NSLocalizedString("Show more", comment: "")
    public static var ellipsisColor = UIColor(hex: "899AB9")

    public static var textAttributes: [String: Any] = [
        NSFontAttributeName: UIFont(font: .Medium, size: 14.0),
      NSForegroundColorAttributeName: UIColor(hex: "FFFFFF")
    ]
  }

  public struct Zoom {
    public static var minimumScale: CGFloat = 1.0
    public static var maximumScale: CGFloat = 3.0
  }
}