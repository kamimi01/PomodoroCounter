//
//  SettingScreen.swift
//  PomodoroCounter
//
//  Created by mikaurakawa on 2023/02/12.
//

import SwiftUI
import AppInfoList

struct SettingScreen: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationView {
            AppInfoListView(
                appearance: AppInfoAppearance(
                    cellTextColor: .mainText,
                    versionTextColor: .mainText,
                    cellTitles: CellTitles(termsOfUse: "利用規約・プライバシーポリシー")
                ),
                info: AppInfo(
                    termOfUseURL: URL(string: "https://kamimi01.github.io/PomodoroCounter/privacy_policy/ja.html")!,
                    appURL: URL(string: "https://apps.apple.com/jp/app/ez-pomo/id1668609447?l=ja")!,
                    developerInfoURL: URL(string: "https://twitter.com/kamimi_01")!,
                    appStoreID: "1668609447"
                ),
                licenseFileURL: Bundle.main.url(forResource: "license-list", withExtension: "plist")!
            )
            .navigationTitle("設定")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading){
                    dismissButton
                }
            }
        }
        .accentColor(.mainText)
    }
}

private extension SettingScreen {
    var dismissButton: some View {
        Button(action: {
            dismiss()
        }) {
            Image(systemName: "multiply")
                .foregroundColor(.mainText)
        }
    }
}

struct SettingScreen_Previews: PreviewProvider {
    static var previews: some View {
        SettingScreen()
    }
}
