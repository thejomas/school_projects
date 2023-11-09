namespace SpaceTaxi_1.Physics {
    public class Accelerate {
        private static Player p;
        public Accelerate(Player player) {
            p = player;
        }

        /// <summary>
        /// Accelerates the player in one of four directions depending on which keys are pressed.
        /// </summary>
        public static void Accelerator(Player player, int UpBool, bool LeftBool,
            bool RightBool, double VerticalTime, double HorizontalTime) {
            double UPS = Game.GameTimer.CapturedUpdates < 1 ? 60 : Game.GameTimer.CapturedUpdates;
            // Landed
            if (UpBool == 0) {
                player.Shape.Direction.X = 0;
                player.Shape.Direction.Y = 0;
                // Down
            } else if (UpBool == 1 && player.Shape.Direction.Y > -0.004f) {
                VerticalTime += (0.003 / UPS);
                player.Shape.Direction.Y -= (float) (0.02f * VerticalTime);
                // Up
            } else if (UpBool == 2 && player.Shape.Direction.Y < 0.004f) {
                VerticalTime += (0.003 / UPS);
                player.Shape.Direction.Y += (float) (0.02f * VerticalTime);
            }
            //Left
            if (LeftBool && player.Shape.Direction.X > -0.004f) {
                HorizontalTime += (0.003 / UPS);
                player.Shape.Direction.X -= (float) (0.02f * HorizontalTime);
            }
            //Right
            if (RightBool && player.Shape.Direction.X < 0.004f) {
                HorizontalTime += (0.003 / UPS);
                player.Shape.Direction.X += (float) (0.02f * HorizontalTime);
            }
        }
    }
}