import Foundation

class PromptService {
    static func getPrompts() -> [JournalPrompt] {
        return [
            JournalPrompt(title: "Dankbarkeit", prompt: "Wofür bist du heute besonders dankbar? Beschreibe drei Dinge, die dir Freude bereitet haben."),
            JournalPrompt(title: "Selbstfürsorge", prompt: "Was hast du heute nur für dich getan? Wie hat sich das angefühlt?"),
            JournalPrompt(title: "Daily Win", prompt: "Was war heute dein größter Erfolg, egal wie klein er scheint? Worauf bist du stolz?"),
            JournalPrompt(title: "Stress-Reflexion", prompt: "Was hat dich heute gestresst? Wie bist du damit umgegangen und was hast du daraus gelernt?"),
            JournalPrompt(title: "Zukunfts-Ich", prompt: "Welchen einen kleinen Schritt kannst du heute tun, um die Person zu werden, die du morgen sein möchtest?")
        ]
    }
}
