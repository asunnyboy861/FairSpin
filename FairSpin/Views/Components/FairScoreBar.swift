import SwiftUI

struct FairScoreBar: View {
    let score: Double
    let total: Double

    var percentage: Double {
        total > 0 ? score / total : 0
    }

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.gray.opacity(0.15))
                    .frame(height: 6)

                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.appPrimary)
                    .frame(width: geometry.size.width * min(percentage, 1.0), height: 6)
            }
        }
        .frame(height: 6)
    }
}
