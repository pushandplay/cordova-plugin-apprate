var plugin = function() {
  return window.AppRate || {};
};
var AppRate = /** @class */ (function() {
  function AppRate() {
  }

  AppRate.locales = plugin().locales;

  AppRate.init = function() {
    var plu = plugin();
    return plu.init.apply(plu, arguments);
  };

  AppRate.setPreferences = function(preferences) {
    var plu = plugin();
    return plu.setPreferences.apply(plu, arguments);
  };

  AppRate.getPreferences = function() {
    var plu = plugin();
    return plu.getPreferences.apply(plu, arguments);
  };

  AppRate.promptForRating = function(immediately) {
    var plu = plugin();
    return plu.promptForRating.apply(plu, arguments);
  };

  AppRate.navigateToAppStore = function() {
    var plu = plugin();
    return plu.navigateToAppStore.apply(plu, arguments);
  };

  return AppRate;
}());
export default AppRate;
