import UIKit

/// Diseño y constraints en la celda prototipo de Main.storyboard.
final class RegistroTableViewCell: UITableViewCell {
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var badgeLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        photo.layer.cornerRadius = 10; photo.clipsToBounds = true
        photo.tintColor = Theme.navy
        badgeLabel.layer.cornerRadius = 8; badgeLabel.clipsToBounds = true
        nameLabel.lineBreakMode = .byTruncatingTail
        detailLabel.lineBreakMode = .byTruncatingTail
        amountLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        badgeLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        nameLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        detailLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        amountLabel.textAlignment = .right
        badgeLabel.textAlignment = .right
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        photo.image = nil; photo.contentMode = .scaleAspectFit; photo.tintColor = Theme.navy
        for label in [nameLabel, detailLabel, amountLabel, badgeLabel] {
            label?.attributedText = nil; label?.text = nil
            label?.backgroundColor = .clear; label?.textColor = Theme.navy
        }
    }
}
