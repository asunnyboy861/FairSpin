import SwiftUI

struct MemberAvatar: View {
    let member: Member
    var size: CGFloat = 40

    var body: some View {
        ZStack {
            Circle()
                .fill(Color(hex: member.colorHex).opacity(0.2))
                .frame(width: size, height: size)

            Text(member.avatarEmoji)
                .font(.system(size: size * 0.5))
        }
    }
}
