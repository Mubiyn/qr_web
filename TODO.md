# Power Bank Rental Web App - TODO List

## Project Overview
**Flutter WEB application** for power bank rental via QR code scanning with Apple Pay/Card payment integration. Users scan QR codes on physical stations and are redirected to this web interface for payment processing.

## Progress Tracking
- ⏳ **In Progress** 
- ✅ **Completed**
- ❌ **Blocked/Issues**
- 📋 **Not Started**

---

## Phase 1: Project Setup & Dependencies

### Dependencies Setup
- [ ] 📋 Update `pubspec.yaml` with required dependencies:
  - [ ] 📋 `dio` - HTTP client for API calls
  - [ ] 📋 `provider` - State management
  - [ ] 📋 `go_router` - Navigation and deep linking
  - [ ] 📋 `flutter_braintree` - Payment processing
  - [ ] 📋 `url_launcher` - For app store links
  - [ ] 📋 `loading_animation_widget` - Loading indicators
  - [ ] 📋 `shared_preferences` - Local storage

### Project Structure
- [ ] 📋 Create folder structure:
  - [ ] 📋 `lib/screens/` - UI screens
  - [ ] 📋 `lib/services/` - API services
  - [ ] 📋 `lib/models/` - Data models
  - [ ] 📋 `lib/providers/` - State management
  - [ ] 📋 `lib/widgets/` - Reusable components
  - [ ] 📋 `lib/utils/` - Helper functions
  - [ ] 📋 `lib/constants/` - App constants

---

## Phase 2: API Integration & Models

### API Service Implementation
- [ ] 📋 Create `ApiService` class with dio client
- [ ] 📋 Implement endpoint methods:
  - [ ] 📋 `generateAccount()` - `/api/v1/auth/apple/generate-account`
  - [ ] 📋 `getBraintreeToken()` - `/api/v1/payments/generate-and-save-braintree-client-token`
  - [ ] 📋 `addPaymentMethod()` - `/api/v1/payments/add-payment-method`
  - [ ] 📋 `createSubscription()` - `/api/v1/payments/subscription/create-subscription-transaction-v2`
  - [ ] 📋 `rentPowerBank()` - `/api/v1/payments/rent-power-bank`

### Data Models
- [ ] 📋 Create model classes:
  - [ ] 📋 `User` model
  - [ ] 📋 `PaymentMethod` model
  - [ ] 📋 `Subscription` model
  - [ ] 📋 `PowerBankRental` model
  - [ ] 📋 `ApiResponse` base model

### Error Handling
- [ ] 📋 Implement custom exception classes
- [ ] 📋 Add network error handling
- [ ] 📋 Add API response validation

---

## Phase 3: State Management (Provider)

### Providers Setup
- [ ] 📋 Create `PaymentProvider`:
  - [ ] 📋 Handle payment flow state
  - [ ] 📋 Manage loading states
  - [ ] 📋 Handle payment method selection
  - [ ] 📋 Process payment transactions

- [ ] 📋 Create `AuthProvider`:
  - [ ] 📋 Manage user account creation
  - [ ] 📋 Handle authentication state

- [ ] 📋 Create `RentalProvider`:
  - [ ] 📋 Manage power bank rental state
  - [ ] 📋 Handle station ID
  - [ ] 📋 Track rental progress

---

## Phase 4: UI Implementation

### PaymentScreen
- [ ] 📋 Create basic screen structure
- [ ] 📋 Implement station ID display
- [ ] 📋 Add payment method selection UI:
  - [ ] 📋 Apple Pay button
  - [ ] 📋 Credit card form
- [ ] 📋 Implement payment processing flow
- [ ] 📋 Add loading indicators
- [ ] 📋 Handle payment success/failure states
- [ ] 📋 Navigation to success screen

### SuccessScreen  
- [ ] 📋 Create success confirmation UI
- [ ] 📋 Add power bank dispensed message
- [ ] 📋 Implement app store link button
- [ ] 📋 Add styling to match design

### Reusable Widgets
- [ ] 📋 Create `CustomButton` widget
- [ ] 📋 Create `LoadingOverlay` widget
- [ ] 📋 Create `PaymentMethodCard` widget
- [ ] 📋 Create `StationInfoCard` widget

---

## Phase 5: Navigation & Deep Links

### Router Setup
- [ ] 📋 Configure `GoRouter` with routes:
  - [ ] 📋 `/payment/:stationId` - PaymentScreen
  - [ ] 📋 `/success` - SuccessScreen
- [ ] 📋 Implement deep link handling for station ID
- [ ] 📋 Add route guards and navigation logic
- [ ] 📋 Handle navigation errors

---

## Phase 6: Payment Integration

### Braintree Setup
- [ ] 📋 Configure Braintree client
- [ ] 📋 Implement Apple Pay integration
- [ ] 📋 Implement credit card payment
- [ ] 📋 Handle payment tokenization
- [ ] 📋 Process payment transactions
- [ ] 📋 Handle payment callbacks

---

## Phase 7: UI Styling & Polish

### Design Implementation
- [ ] 📋 Create app color scheme and theme
- [ ] 📋 Implement responsive design for web
- [ ] 📋 Match UI to provided screenshots:
  - [ ] 📋 Payment screen layout
  - [ ] 📋 Success screen design
  - [ ] 📋 Loading states
  - [ ] 📋 Error states

### Animations & UX
- [ ] 📋 Add smooth transitions between screens
- [ ] 📋 Implement loading animations
- [ ] 📋 Add micro-interactions
- [ ] 📋 Ensure accessibility standards

---

## Phase 8: Testing & Integration

### Functionality Testing
- [ ] 📋 Test with provided station ID: `RECH082203000350`
- [ ] 📋 Test payment flow end-to-end:
  - [ ] 📋 Account generation
  - [ ] 📋 Payment method addition
  - [ ] 📋 Subscription creation
  - [ ] 📋 Power bank rental
- [ ] 📋 Test deep link handling
- [ ] 📋 Test error scenarios

### Edge Cases
- [ ] 📋 Handle network failures
- [ ] 📋 Handle payment failures
- [ ] 📋 Handle invalid station IDs
- [ ] 📋 Handle API timeout scenarios

---

## Phase 9: Final Polish & Deployment

### Code Quality
- [ ] 📋 Code review and refactoring
- [ ] 📋 Add documentation and comments
- [ ] 📋 Optimize performance
- [ ] 📋 Remove debug code

### Deployment Preparation
- [ ] 📋 Configure web build settings
- [ ] 📋 Test production build
- [ ] 📋 Prepare for deployment
- [ ] 📋 Create deployment documentation

---

## API Endpoints Reference

### Base URL: `https://goldfish-app-3lf7u.ondigitalocean.app`

1. **Account Creation**: `POST /api/v1/auth/apple/generate-account`
2. **Braintree Token**: `GET /api/v1/payments/generate-and-save-braintree-client-token`
3. **Add Payment**: `POST /api/v1/payments/add-payment-method`
4. **Subscription**: `POST /api/v1/payments/subscription/create-subscription-transaction-v2?disableWelcomeDiscount=false&welcomeDiscount=10`
   - Body: `{ 'paymentToken': paymentToken, 'thePlanId': 'tss2' }`
5. **Rent Power Bank**: `POST /api/v1/payments/rent-power-bank`

### Test Data
- **Station ID**: `RECH082203000350`

---

## Notes & Considerations

- [ ] 📋 **PRIMARY: Optimize for mobile browsers** (users scan QR with phones)
- [ ] 📋 **Ensure Safari compatibility** for Apple Pay on iOS
- [ ] 📋 **Responsive design** for various screen sizes
- [ ] 📋 Handle CORS issues if any
- [ ] 📋 Implement proper error messaging in Russian if needed
- [ ] 📋 Consider offline scenarios
- [ ] 📋 Ensure security best practices for payment handling
- [ ] 📋 **Web-specific**: Handle browser compatibility issues
- [ ] 📋 **Web-specific**: Optimize loading times for mobile networks

---

## Current Status: Ready to Start Phase 1
**Next Action**: Update pubspec.yaml with required dependencies
