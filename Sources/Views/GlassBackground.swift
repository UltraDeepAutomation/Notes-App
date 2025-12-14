import SwiftUI
import AppKit

/// NSVisualEffectView wrapper для Glass эффекта
struct VisualEffectBackground: NSViewRepresentable {
    var material: NSVisualEffectView.Material
    var blendingMode: NSVisualEffectView.BlendingMode
    var state: NSVisualEffectView.State
    
    init(
        material: NSVisualEffectView.Material = .hudWindow,
        blendingMode: NSVisualEffectView.BlendingMode = .behindWindow,
        state: NSVisualEffectView.State = .active
    ) {
        self.material = material
        self.blendingMode = blendingMode
        self.state = state
    }
    
    func makeNSView(context: Context) -> NSVisualEffectView {
        let view = NSVisualEffectView()
        view.material = material
        view.blendingMode = blendingMode
        view.state = state
        view.wantsLayer = true
        return view
    }
    
    func updateNSView(_ nsView: NSVisualEffectView, context: Context) {
        nsView.material = material
        nsView.blendingMode = blendingMode
        nsView.state = state
    }
}

/// Liquid Glass стиль фона
struct GlassBackground: View {
    var cornerRadius: CGFloat = 16
    var opacity: Double = 0.6
    
    var body: some View {
        ZStack {
            VisualEffectBackground(material: .hudWindow, blendingMode: .behindWindow)
            
            // Градиентная подсветка сверху (эффект стекла)
            LinearGradient(
                colors: [
                    Color.white.opacity(0.15),
                    Color.white.opacity(0.05),
                    Color.clear
                ],
                startPoint: .top,
                endPoint: .center
            )
            
            // Тонкая граница
            RoundedRectangle(cornerRadius: cornerRadius)
                .strokeBorder(
                    LinearGradient(
                        colors: [
                            Color.white.opacity(0.3),
                            Color.white.opacity(0.1)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 0.5
                )
        }
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
    }
}

/// Модификатор для применения Glass эффекта
extension View {
    func glassBackground(cornerRadius: CGFloat = 16) -> some View {
        self.background(GlassBackground(cornerRadius: cornerRadius))
    }
}
