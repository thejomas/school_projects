
namespace SpaceTaxi_1 {
    internal class Program {
        public static void Main() {
            Game game = Game.GetInstance();
            game.GameLoop();
        }
    }
}