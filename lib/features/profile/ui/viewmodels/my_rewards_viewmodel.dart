import 'package:bondly_app/features/base/ui/viewmodels/base_model.dart';
import 'package:bondly_app/features/profile/domain/models/rewards_list_model.dart';
import 'package:logger/logger.dart';

class MyRewardsViewModel extends NavigationModel {
  Logger log = Logger(
    printer: PrettyPrinter(methodCount: 0),
  );

  MyRewardsViewModel() {
    log.i("MyRewardsViewModel Created");
  }

  RewardList _rewardList = RewardList(rewards: [
    Reward(
        id: "64f104bd76f0bc2ec94c2f17",
        name: "Acuario Inbursa (CDMX)",
        description: "Entrada general para 1 persona",
        category: "Experiencias",
        points: 10,
        deadline: DateTime.parse("2023-12-31T00:00:00.000Z"),
        companyName: "DisolutionsMx",
        enable: true,
        visible: true,
        likes: [],
        createdAt: DateTime.parse("2023-08-31T21:23:09.476Z"),
        updatedAt: DateTime.parse("2023-08-31T21:23:09.476Z"),
        image: "https://api.bondly.mx/public/upload/1693518208339.jpg"),
    Reward(
        id: "64f104bd76f0bc2ec9as4c2f17",
        name: "Acuario Inbursa (CDMX)",
        description: "Entrada general para 1 persona",
        category: "Experiencias",
        points: 10,
        deadline: DateTime.parse("2023-12-31T00:00:00.000Z"),
        companyName: "DisolutionsMx",
        enable: true,
        visible: true,
        likes: [],
        createdAt: DateTime.parse("2023-08-31T21:23:09.476Z"),
        updatedAt: DateTime.parse("2023-08-31T21:23:09.476Z"),
        image: "https://api.bondly.mx/public/upload/1693518208339.jpg"),
    Reward(
        id: "64f104bd76f0bc2esac94c2f17",
        name: "Acuario Inbursa (CDMX)",
        description: "Entrada general para 1 persona",
        category: "Experiencias",
        points: 10,
        deadline: DateTime.parse("2023-12-31T00:00:00.000Z"),
        companyName: "DisolutionsMx",
        enable: true,
        visible: true,
        likes: [],
        createdAt: DateTime.parse("2023-08-31T21:23:09.476Z"),
        updatedAt: DateTime.parse("2023-08-31T21:23:09.476Z"),
        image: "https://api.bondly.mx/public/upload/1693518208339.jpg")
  ]);

  RewardList get rewardList => _rewardList;

  set rewardList(RewardList rewardList) {
    _rewardList = rewardList;
    notifyListeners();
  }

  Map<String, int> itemQuantities = {};

  void addToCart(String itemId) {
    if (itemQuantities.containsKey(itemId)) {
      itemQuantities[itemId] = (itemQuantities[itemId] ?? 0) + 1;
    } else {
      itemQuantities[itemId] = 1;
    }
    notifyListeners(); // Asegúrate de notificar cambios en el modelo.
  }

  void removeFromCart(String itemId) {
    if (itemQuantities.containsKey(itemId)) {
      itemQuantities[itemId] = (itemQuantities[itemId] ?? 0) - 1;
      if (itemQuantities[itemId] == 0) {
        itemQuantities.remove(itemId);
      }
      notifyListeners();
    }
  }

  int getItemCount(String itemId) {
    return itemQuantities[itemId] ?? 0;
  }

  @override
  void dispose() {
    log.i("MyRewardsViewModel Disposed");
    super.dispose();
  }
}
