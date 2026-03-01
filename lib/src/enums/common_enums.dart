enum ProductType { single, variable }

enum TextSizes { small, medium, large }

enum OrderStatus { processing, shipped, delivered, pending, cancelled }

enum PaymentMethods {
  paypal,
  googlePay,
  applePay,
  visa,
  masterCard,
  creditCard,
  paystack,
  razorPay,
  paytm
}

enum ImagesType { asset, network, memory, file }

enum AppRole { admin, user }

enum TransactionType { buy, sell }

enum ProductVisibility { published, hidden }

enum MediaCategory { folders, banners, brands, categories, products, users }


/// Whether the conversation with the LLM is [idle] waiting for the user,
/// or [busy] generating output.
/// or [working] on a task.
enum ConversationState { idle, busy, working }

// wether the wallet service is loading or done
enum WalletServiceState { loading, done, error }

/// Represents the role of a message sender (user or LLM).
enum MessageRole { user, llm }

/// Represents the state of a message (complete or streaming).
enum MessageState { complete, streaming }

enum LoaderState { loading, done, error, Initial }

