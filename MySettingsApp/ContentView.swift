//
//  ContentView.swift
//  MySettingsApp
//
//  Created by Samantha Roman on 12/5/25.
//

import SwiftUI // SwiftUI toolbox so we can build screens

struct ContentView: View { // building block of the basic screen
    
    // the current choices we want the app to remember while running.
    // We do that with @State.
    // "@State is saying Hey SwiftUI the value might change, when it does, please re render the part of the screen that uses it. EXample. If you erase "pizza night" off my sticky note on the fridge and write "tacos" the whole family's evening changes."
    
    @State private var isDarkMode: Bool = false // true/false switch for dark mode starting at false for light theme is ON
    @State private var fontSize: Double = 16 // base font is 16 moves in single points not decimals
    @State private var accentColor: Color = .pink // accent color for buttons/text
    
    // 1. Load from UserDefaults
    private func loadSettings() { // helper func READS fr UserDefaulsts updates @State values
        let defaults = UserDefaults.standard
        
        isDarkMode = defaults.bool(forKey: "isDarkMode")
        
        let savedFontSize = defaults.double(forKey: "fontSize")
        if savedFontSize != 0 { // if nothing new use default
            fontSize = savedFontSize
        }
    }
    
    // 2. Save to userDefaults
    private func saveSettings() { // helper func that WRITES current settings into UserDefaults
        let defaults = UserDefaults.standard
        defaults.set(isDarkMode, forKey: "isDarkMode")
        defaults.set(fontSize, forKey: "fontSize")
    }
    
    var body: some View { // the layout instructions
        NavigationStack {
            Form {
                Section("Theme") {
                    // Theme controls w/ Toggle "dark/light mode w/ Helper preview
                    Toggle("Dark Mode", isOn: $isDarkMode)
                    Text(isDarkMode ? "Dark mode is ON" : "Dark mode is OFF")
                        .font(.caption)
                        .foregroundColor(.secondary)
                } // End Theme
                Section("Font Size") {
                    // Font size slider controls w/ optional preview of chosen size
                    Slider(value: $fontSize, in: 12...36, step: 1)
                    // optional preview
                    HStack {
                        Text("Sample Text")
                            .font(.system(size: fontSize))
                            .foregroundColor(.primary)
                        Spacer()
                        Text("\(Int(fontSize)) pt")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                } // End Font
                Section("Accent Color") {
                    // Accent color buttons controls goes here
                    HStack {
                        ColorCircleButton(color: .pink, selectedColor: $accentColor)
                        ColorCircleButton(color: .blue, selectedColor: $accentColor)
                        ColorCircleButton(color: .green, selectedColor: $accentColor)
                    }
                } // End Accent
                Section("Preview") {
                    // preview with layered layout
                    ZStack {
                        RoundedRectangle(cornerRadius: 16)
                            .fill(isDarkMode ? Color.black : Color.white)
                            .shadow(radius: 4)
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                            )
                        
                        VStack(spacing: 8) {
                            Text("Live Preview")
                                .font(.system(size: fontSize, weight: .semibold))
                                .foregroundColor(accentColor)
                            
                            Text("This is how your text will look with the current settings.")
                                .font(.system(size: max(fontSize - 2, 10)))
                                .foregroundColor(isDarkMode ? Color.white.opacity(0.8) : Color.black.opacity(0.7))
                                .multilineTextAlignment(.center)
                                .padding(.horizontal)
                        }
                        .padding()
                    }
                    .frame(height: 160)
                } // End Preview
            } // End Form
            .navigationTitle("App Settings")
        } // End NavStack
        .onAppear { // When the view first shows up run this code. (call loadSettings())
            loadSettings() // reads any stored values -> updates @State -> SwiftUI redraws
        }
        .onChange(of: isDarkMode) { newValue in
            saveSettings()
        }
        .onChange(of: fontSize) { newValue in
            saveSettings()
        }
    }
}
struct ColorCircleButton: View {
    let color: Color
    @Binding var selectedColor: Color
    
    var body: some View {
        Circle()
            .fill(color)
            .frame(width: 32, height: 32)
            .onTapGesture {
                selectedColor = color
            }
            .overlay(
                Circle()
                    .stroke(Color.primary.opacity(selectedColor == color ? 1 : 0), lineWidth: 2)
            )
    }
}
#Preview { // in Xcode's preview area show me what this "view" looks like
    ContentView()
}
