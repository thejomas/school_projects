using DIKUArcade.EventBus;

namespace SpaceTaxi_1 {
    public class TaxiBus {
        private static GameEventBus<object> eventBus;

        /// <summary>
        /// Returns the currently active eventbus
        /// </summary>
        public static GameEventBus<object> GetBus() {
            return TaxiBus.eventBus ?? (TaxiBus.eventBus =
                       new GameEventBus<object>());
        }
    }
}