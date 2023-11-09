using System.Collections.Generic;
using System.IO;
using DIKUArcade.Entities;
using DIKUArcade.EventBus;
using DIKUArcade.Graphics;
using DIKUArcade.Math;

namespace SpaceTaxi_1 {
    public class Player : IGameEventProcessor<object> {
        private static Player instance;

        public Entity Entity;
        public DynamicShape Shape;
        public Orientation TaxiOrientation;

        private GameEventBus<object> eventBus;

        public static Image[] images;
        public static ImageStride[,] imageStrides;

        private List<Image> explosionStrides;
        public AnimationContainer Explosions;
        private int EXPLOSION_LENGTH = 500;

        private int lrImg;

        public int UpVal;
        public bool LeftBool;
        public bool RightBool;
        public double VerticalTime;
        public double HorizontalTime;
        public char PlatformVal;

        public static Player GetInstance() {
            return Player.instance ?? (Player.instance = new Player());
        }

        /// <summary>
        /// Creates a player by adding it as an entity with the needed shape and the correct images.
        /// </summary>
        private Player() {
            Shape = new DynamicShape(new Vec2F(), new Vec2F());

            images = new Image[2];
            imageStrides = new ImageStride[2,3];

            images[0] = new Image(Path.Combine("Assets", "Images",
                "Taxi_Thrust_None.png"));
            images[1] = new Image(Path.Combine("Assets", "Images",
                "Taxi_Thrust_None_Right.png"));

            imageStrides[0,0] = new ImageStride(1, ImageStride.CreateStrides(2, Path.Combine(
                "Assets", "Images", "Taxi_Thrust_Back.png")));
            imageStrides[1,0] = new ImageStride(1, ImageStride.CreateStrides(2, Path.Combine(
                "Assets", "Images", "Taxi_Thrust_Back_Right.png")));
            imageStrides[0,1] = new ImageStride(1, ImageStride.CreateStrides(2, Path.Combine(
                "Assets", "Images", "Taxi_Thrust_Bottom.png")));
            imageStrides[1,1] = new ImageStride(1, ImageStride.CreateStrides(2, Path.Combine(
                "Assets", "Images", "Taxi_Thrust_Bottom_Right.png")));
            imageStrides[0,2] = new ImageStride(1, ImageStride.CreateStrides(2, Path.Combine(
                "Assets", "Images", "Taxi_Thrust_Bottom_Back.png")));
            imageStrides[1,2] = new ImageStride(1, ImageStride.CreateStrides(2, Path.Combine(
                "Assets", "Images", "Taxi_Thrust_Bottom_Back_Right.png")));

            explosionStrides = ImageStride.CreateStrides(8,
                Path.Combine("Assets/Images/Explosion.png"));
            Explosions = new AnimationContainer(1);

            eventBus = TaxiBus.GetBus();
            eventBus.Subscribe(GameEventType.GameStateEvent, this);

            Entity = new Entity(Shape, images[0]);

            UpVal = 1;
        }

        public void Move() {
            Physics.Accelerate.Accelerator(Player.GetInstance(), UpVal, LeftBool, RightBool,
                VerticalTime, HorizontalTime);
            Shape.Move();
        }

        /// <summary>
        /// Used to set the position of the player.
        /// </summary>
        /// <param name="x"> The x-coordinate (from 0-1). </param>
        /// <param name="y"> The y-coordinate (from 0-1). </param>
        public void SetPosition(float x, float y) {
            Shape.Position.X = x;
            Shape.Position.Y = y;
            Shape.Direction.X = 0;
            Shape.Direction.Y = 0;
            VerticalTime = 0.001f;
            HorizontalTime = 0.001f;
        }

        /// <summary>
        /// Sets the size of the player.
        /// </summary>
        /// <param name="width"> The desired width. </param>
        /// <param name="height"> The desired width. </param>
        public void SetExtent(float width, float height) {
            Shape.Extent.X = width;
            Shape.Extent.Y = height;
        }

        /// <summary>
        /// Changing the image depending on the orientation of the player and then renders it.
        /// </summary>
        public void ChooseOrientation() {
            if (TaxiOrientation == Orientation.Left) {
                lrImg = 0;
            } else if (TaxiOrientation == Orientation.Right) {
                lrImg = 1;
            }

            if (UpVal == 1 && (LeftBool || RightBool)) {
                Entity.Image = imageStrides[lrImg, 0];
            } else if (UpVal == 1) {
                Entity.Image = images[lrImg];
            } else if (UpVal == 2 && (LeftBool || RightBool)) {
                Entity.Image = imageStrides[lrImg, 2];
            } else if (UpVal == 2) {
                Entity.Image = imageStrides[lrImg, 1];
            }
        }

        /// <summary>
        /// Adds an Animation (explosion) and changes the GameState to GameOVer.
        /// </summary>
        /// <param name="posX"> x-coordinate of the position. </param>
        /// <param name="posY"> y-coordinate of the position. </param>
        /// <param name="extentX"> x-coordinate of the extent. </param>
        /// <param name="extentY"> y-coordinate of the extent. </param>
        public void AddExplosions(float posX, float posY, float extentX, float extentY) {
            Explosions.AddAnimation(
                new StationaryShape(posX, posY, extentX, extentY), EXPLOSION_LENGTH,
                new ImageStride(EXPLOSION_LENGTH / 8, explosionStrides));

            eventBus.RegisterEvent(
                GameEventFactory<object>.CreateGameEventForAllProcessors(
                    GameEventType.GameStateEvent,
                    this,
                    "CHANGE_STATE",
                    "GAME_OVER", ""));

            UpVal = 1;
            LeftBool = false;
            RightBool = false;
        }

        /// <summary>
        /// Processes all eventtypes.
        /// </summary>
        /// <param name="eventType"> GameEventTypes are concerned with which entity can handle the
        /// given events. (This will be GameEventType.PlayerEvent for this class). </param>
        /// <param name="gameEvent"> GameEvent object are different kind of events, most often a
        /// gameEvent.Message which is the keyinput as a message. </param>
        public void ProcessEvent(GameEventType eventType, GameEvent<object> gameEvent) {
            if (eventType == GameEventType.PlayerEvent) {
                switch (gameEvent.Message) {
                case "BOOSTER_UPWARDS":
                    VerticalTime = 0.001f;
                    UpVal = 2;
                    break;

                case "BOOSTER_TO_LEFT":
                    HorizontalTime = 0.001f;
                    LeftBool = true;
                    TaxiOrientation = Orientation.Left;
                    break;

                case "BOOSTER_TO_RIGHT":
                    HorizontalTime = 0.001f;
                    RightBool = true;
                    TaxiOrientation = Orientation.Right;
                    break;

                case "STOP_ACCELERATE_UP":
                    VerticalTime = 0.001f;
                    UpVal = 1;
                    break;

                case "STOP_ACCELERATE_LEFT":
                    LeftBool = false;
                    break;

                case "STOP_ACCELERATE_RIGHT":
                    RightBool = false;
                    break;
                }
            }
        }
    }
}
