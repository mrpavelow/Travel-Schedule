import SwiftUI

struct MainView: View {
    @State private var stories: [Story] = Story.all
    
    @State private var showStories = false
    @State private var selectedStoryIndex = 0
    
    let fromCity: City?
    let toCity: City?
    let fromStation: Station?
    let toStation: Station?
    
    let onTapFrom: () -> Void
    let onTapTo: () -> Void
    let onSwap: () -> Void
    let onFind: () -> Void
    let onOpenFilters: () -> Void
    
    private var fromText: String? {
        fromStation?.title ?? fromCity?.title
    }
    
    private var toText: String? {
        toStation?.title ?? toCity?.title
    }
    
    private var canFind: Bool {
        fromText != nil && toText != nil
    }
    
    var body: some View {
        ZStack {
            Color(.ypWhiteU).ignoresSafeArea()
            
            VStack(spacing: 44) {
                StoriesPreviewBar(stories: stories) { index in
                    selectedStoryIndex = index
                    showStories = true
                }
                .padding(.top, 8)
                
                VStack(spacing: 16) {
                    SearchFormCard(
                        fromTitle: "Откуда",
                        fromValue: fromText,
                        toTitle: "Куда",
                        toValue: toText,
                        onTapFrom: onTapFrom,
                        onTapTo: onTapTo,
                        onSwap: onSwap
                    )
                    
                    Button(action: onFind) {
                        Text("Найти")
                            .font(.system(size: 17, weight: .bold))
                            .frame(width: 150, height: 60)
                            .background(Color(.ypBlue))
                            .foregroundStyle(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                    }
                    .opacity(canFind ? 1 : 0)
                    
                    Spacer()
                }
                .padding(.horizontal, 16)
            }
        }
        .fullScreenCover(isPresented: $showStories) {
            ContentView(
                isPresented: $showStories,
                stories: $stories,
                startIndex: selectedStoryIndex
            )
            
        }
    }
}

// MARK: - Search Form (blue container)

private struct SearchFormCard: View {
    let fromTitle: String
    let fromValue: String?
    let toTitle: String
    let toValue: String?
    
    let onTapFrom: () -> Void
    let onTapTo: () -> Void
    let onSwap: () -> Void
    
    var body: some View {
        ZStack(alignment: .trailing) {
            Color(.ypBlue)
                .clipShape(RoundedRectangle(cornerRadius: 20))
            
            HStack(spacing: 0) {
                VStack(spacing: 0) {
                    SearchRow(
                        placeholder: fromTitle,
                        value: fromValue,
                        onTap: onTapFrom,
                        showChevron: false
                    )
                    
                    SearchRow(
                        placeholder: toTitle,
                        value: toValue,
                        onTap: onTapTo,
                        showChevron: false
                    )
                }
                .frame(width: 259, height: 96)
                .background(Color(.ypWhite))
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .padding(.leading, 20)
                .padding(.vertical, 20)
                
                Spacer(minLength: 0)
                
                SwapButton(action: onSwap)
                    .padding(.trailing, 20)
            }
        }
        .frame(height: 128)
    }
}

private struct SearchRow: View {
    let placeholder: String
    let value: String?
    let onTap: () -> Void
    var showChevron: Bool = false
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 12) {
                Text(displayText)
                    .font(.system(size: 17, weight: .regular))
                    .foregroundStyle(value == nil ? Color(.ypGray) : Color(.ypBlack))
                    .lineLimit(1)
                
                Spacer()
                
                if showChevron {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(Color(.ypGray))
                }
            }
            .padding(.horizontal, 20)
            .frame(height: 48)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
    
    private var displayText: String {
        if let value, !value.isEmpty {
            return value
        }
        return placeholder
    }
}

private struct SwapButton: View {
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image("Сhange")
                .font(.system(size: 16, weight: .bold))
                .foregroundStyle(Color(.ypBlue))
                .frame(width: 44, height: 44)
                .background(Color(.ypWhite))
                .clipShape(Circle())
                .overlay(
                    Circle().stroke(Color.black.opacity(0.04), lineWidth: 1)
                )
                .shadow(color: Color.black.opacity(0.08), radius: 6, x: 0, y: 2)
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Button row

private struct ButtonRow: View {
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Text(title)
                    .font(.system(size: 17, weight: .regular))
                    .foregroundStyle(Color(.ypBlackU))
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(Color(.ypGray))
            }
            .padding(.horizontal, 16)
            .frame(height: 56)
            .background(Color(.ypWhiteU))
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
    }
}
