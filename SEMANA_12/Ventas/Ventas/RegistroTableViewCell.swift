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
    }
}
