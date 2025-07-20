import SwiftUI

struct WordCloudView: View {
    let tagFrequencies: [String: Int]

    private var sortedTags: [(String, Int)] {
        tagFrequencies.sorted { $0.value > $1.value }
    }

    private var maxFrequency: Int {
        sortedTags.first?.1 ?? 1
    }

    var body: some View {
        VStack(alignment: .leading) {
            Text("Häufigste Tags")
                .font(.custom("Montserrat-Bold", size: 22))
                .foregroundColor(.brandPrimary)
                .padding(.bottom, 10)

            if sortedTags.isEmpty {
                ContentUnavailableView(
                    "Keine Tags gefunden",
                    systemImage: "tag.slash",
                    description: Text("Verwende Tags in deinen Einträgen, um hier eine Analyse zu sehen.")
                )
                .frame(minHeight: 150)
            } else {
                // Simple Flow Layout implementation
                var width = CGFloat.zero
                var height = CGFloat.zero
                
                GeometryReader { geometry in
                    ZStack(alignment: .topLeading) {
                        ForEach(self.sortedTags, id: \.0) { tag, count in
                            self.item(for: tag, count: count)
                                .padding([.horizontal, .vertical], 4)
                                .alignmentGuide(.leading, computeValue: { d in
                                    if (abs(width - d.width) > geometry.size.width) {
                                        width = 0
                                        height -= d.height
                                    }
                                    let result = width
                                    if tag == self.sortedTags.last!.0 {
                                        width = 0 // last item
                                    } else {
                                        width -= d.width
                                    }
                                    return result
                                })
                                .alignmentGuide(.top, computeValue: { d in
                                    let result = height
                                    if tag == self.sortedTags.last!.0 {
                                        height = 0 // last item
                                    }
                                    return result
                                })
                        }
                    }
                }
                .frame(minHeight: 150)
            }
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(12)
    }

    private func item(for text: String, count: Int) -> some View {
        Text("#\(text)")
            .font(.custom("Inter-Regular", size: fontSize(for: count)))
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .foregroundColor(.white)
            .background(color(for: count))
            .cornerRadius(16)
    }

    private func fontSize(for count: Int) -> CGFloat {
        let normalized = CGFloat(count) / CGFloat(maxFrequency)
        return 14 + (normalized * 18)
    }
    
    private func color(for count: Int) -> Color {
        let normalized = Double(count) / Double(maxFrequency)
        return Color.brandPrimary.interpolate(to: .brandAccent, fraction: normalized)
    }
}

#Preview {
    let mockTags = ["dankbar": 10, "stress": 8, "arbeit": 5, "freunde": 7, "müde": 3, "sport": 4, "idee": 6]
    return WordCloudView(tagFrequencies: mockTags)
        .padding()
}
