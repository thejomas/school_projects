using System;
using DIKUArcade.Entities;
using DIKUArcade.EventBus;
using DIKUArcade.Physics;
using SpaceTaxi_1.TaxiStates;

namespace SpaceTaxi_1.Physics {
    public class CollisionHandler {
        private GameEventBus<object> _eventBus;
        public CollisionHandler() {
            _eventBus = TaxiBus.GetBus();
        }

        public void CheckAllCollisions(Player player) {
            CheckPlatformCollision(player);
            CheckEnviromentCollision(player);
            CheckNextLevelCollision();
        }

        /// <summary>
        /// Checks for collision between the player and a platform.
        /// </summary>
        /// <param name="player"> The player instance </param>
        public void CheckPlatformCollision(Player player) {
            foreach (EntityContainer ent in Level.Level.PlatformID.Values) {
                foreach (Entity entity in ent) {
                    CollisionData colData =
                        CollisionDetection.Aabb(player.Entity.Shape as DynamicShape, entity.Shape);
                    if (!colData.Collision) {
                        continue;
                    }

                    if (player.Shape.Direction.X < 0.0025f && player.Shape.Direction.X > -0.0025f &&
                        player.Shape.Direction.Y < 0.0025f && player.Shape.Direction.Y > -0.0025f) {
                        player.UpVal = 0;
                    } else {
                        player.AddExplosions(player.Entity.Shape.Position.X,
                            player.Entity.Shape.Position.Y, player.Entity.Shape.Extent.X,
                            player.Entity.Shape.Extent.Y);
                    }
                }
            }
        }

        /// <summary>
        /// Checks for collision between a player and the surrounding environment.
        /// </summary>
        /// <param name="player"> The player instance </param>
        public void CheckEnviromentCollision(Player player) {
            foreach (Entity ent in Level.Level.LevelEntities) {
                CollisionData colData =
                    CollisionDetection.Aabb(player.Entity.Shape as DynamicShape, ent.Shape);
                if (colData.Collision) {
                    player.AddExplosions(player.Entity.Shape.Position.X,
                        player.Entity.Shape.Position.Y, player.Entity.Shape.Extent.X,
                        player.Entity.Shape.Extent.Y);
                }
            }
        }

        /// <summary>
        /// Checks if the player is above the top line of the screen, and changing the level if this
        /// is the case.
        /// </summary>
        public void CheckNextLevelCollision() {
            if (!(GameRunning.Player.Entity.Shape.Position.Y > 1.0)) {
                return;
            }
            GameRunning.Level.LevelNumber++;
            try {
                GameRunning.Level.CreateNewLevel();
            } catch (ArgumentOutOfRangeException) {
                _eventBus.RegisterEvent(
                    GameEventFactory<object>.CreateGameEventForAllProcessors(
                        GameEventType.WindowEvent,
                        this,
                        "CLOSE_WINDOW", "", "")
                );
            }

            GameRunning.Player.SetPosition(Level.Level.PlayerStartPosX,
                Level.Level.PlayerStartPosY);
        }
    }
}