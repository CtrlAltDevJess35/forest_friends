

// Definition der Sprecher im Dialogsystem
enum Speaker { player, forester }

// Struktur für einzelne Dialogeinträge
class DialogueSetup{
  final String text;
  final Speaker speaker;

  DialogueSetup(this.text, this.speaker);
}

class DialogueData {
  // Der Dialog mit dem Förster am Anfang des Spiels
  static List<DialogueSetup> foresterGreeting = [
    DialogueSetup("Hallo Förster! Brauchst du Hilfe?", Speaker.player),
    DialogueSetup("Hallo Wanderer! Oh ja, gerne! Würdest du das denn wirklich tun?", Speaker.forester),
    DialogueSetup("Ja, klar. Ich hab schon gesehen, dass die Bäume und Pflanzen ganz trocken aussehen!", Speaker.player),
    DialogueSetup("Ja, die Bäume und Pflanzen brauchen unbedingt Wasser, ich kam noch nicht dazu, es war so viel zu erledigen.", Speaker.forester),
    DialogueSetup("Dann lass mich das doch machen. Kann ich einen Eimer oder so von dir benutzen?", Speaker.player),
    DialogueSetup("Das wäre super. Natürlich, du kannst den Eimer dort nehmen, aber du müsstest immer zum Brunnen dahinten gehen und jedes Mal Wasser holen.", Speaker.forester),
    DialogueSetup("Ach, das macht nichts. Ich kümmer mich gern um Pflanzen und Bäume und dann noch gleichzeitig um den Wald.", Speaker.player),
    DialogueSetup("Ach, super! Schon mal vielen Dank dafür! Vielleicht könntest du mir noch einen weiteren Gefallen tun?", Speaker.forester),
    DialogueSetup("Gern. Was kann ich sonst tun?", Speaker.player),
    DialogueSetup("Da hinten sind noch zwei Maisfelder. Dort müsste noch Mais gesät und geenrtet werden. Wäre das wohl möglich?", Speaker.forester),
    DialogueSetup("Klar. Ich kümmere mich drum.", Speaker.player),
    DialogueSetup("Super!! Vielen Dank!", Speaker.forester),
  ];

    // Dialog nachdem der Spieler alle Aufgaben erledigt hat
  static List<DialogueSetup> foresterThanks = [
    DialogueSetup("Ich habe alle Pflanzen und Bäume gegossen und den Mais hab ich auch geenrtet. Brauchst du sonst noch bei was Hilfe?", Speaker.player),
    DialogueSetup("Ach, super! Nein, damit hast du mir schon unheimlich viel geholfen. Vielen Dank!", Speaker.forester),
    DialogueSetup("Du darfst jederzeit gerne wiederkommen und helfen. Vielen Dank nochmal, die Pflanzen und Bäume sehen auch wieder so schön grün aus.", Speaker.forester),
    DialogueSetup("Kein Problem! Hab ich gern gemacht und ich helfe auch gerne wieder! Hab einen schönen Tag!", Speaker.player),
    DialogueSetup("Du auch, mein Waldfreund!!", Speaker.forester),
  ];

  // Methode zur Auswahl des Dialogs basierend auf dem Status
  static List<DialogueSetup> getForesterDialogue(bool tasksCompleted) {
    return tasksCompleted ? foresterThanks : foresterGreeting;
  }
}