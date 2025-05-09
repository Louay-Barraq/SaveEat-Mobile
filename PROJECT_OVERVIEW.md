# SaveEat Mobile Application Overview

## Project Description
SaveEat is a Flutter-based mobile application designed to help monitor and reduce food waste in food service establishments. The application provides real-time monitoring, analytics, and reporting features to track food waste across different meal times and locations.

## Technical Stack
- **Framework**: Flutter
- **Language**: Dart
- **UI Components**: Material Design
- **Charts**: fl_chart package

## Application Structure

### Core Features
1. **Dashboard**
   - Real-time waste monitoring
   - Daily statistics comparison
   - Table monitoring status
   - Weekly and monthly waste trends
   - Meal-time waste distribution (Breakfast, Lunch, Dinner)

2. **Robot Integration**
   - Interface for robot control and monitoring
   - Real-time robot status and operations

3. **QR Code Scanning**
   - QR code-based identification system
   - Integration with monitoring system

4. **Reports**
   - Detailed waste analytics
   - Historical data analysis
   - Performance metrics

5. **Settings**
   - Application configuration
   - User preferences
   - System settings

### Directory Structure

```
lib/
├── main.dart           # Application entry point
├── pages/             # Main application screens
│   ├── dashboard_page.dart
│   ├── robot_page.dart
│   ├── qr_scan_page.dart
│   ├── reports_page.dart
│   └── settings_page.dart
└── components/        # Reusable widgets
    ├── Charts
    │   ├── monthly_chart_widget.dart
    │   ├── weekly_chart_widget.dart
    │   └── waste_by_time_pie_chart_widget.dart
    ├── UI Elements
    │   ├── action_button_widget.dart
    │   ├── colored_button_widget.dart
    │   ├── container_widget.dart
    │   └── toggle_switch_component_widget.dart
    └── Dashboard Elements
        ├── dashboard_stats_widget.dart
        ├── day_date_widget.dart
        └── report_infos_widget.dart
```

## UI/UX Features
- Clean, modern interface with consistent design language
- Bottom navigation for easy access to main features
- Custom fonts (Inconsolata) for better readability
- Responsive design with smooth transitions
- Interactive charts and statistics visualization
- Custom-designed icons for navigation

## Key Components

### Navigation
- Bottom navigation bar with five main sections
- Custom icons for each section
- Smooth page transitions with swipe capability

### Dashboard Widgets
1. **Day Date Widget**: Displays current date information
2. **Dashboard Stats Widget**: Shows comparative statistics
3. **Weekly Chart**: Visualizes waste trends over a week
4. **Monthly Chart**: Displays monthly waste patterns
5. **Waste Time Pie Chart**: Breaks down waste by meal times

### Interactive Elements
- Action buttons for user interactions
- Toggle switches for settings
- Container widgets for content organization
- Info widgets for detailed information display

## Design Philosophy
The application follows a minimalist design approach with:
- Consistent color scheme (primary colors and grays)
- Clear typography with the Inconsolata font family
- Subtle shadows and elevations for depth
- Intuitive navigation patterns
- Data-driven visualizations

## Future Enhancements
Potential areas for expansion include:
- Advanced analytics integration
- Real-time notifications
- Multi-language support
- Enhanced robot control features
- Extended reporting capabilities

---

## Data Models & Database Planning

### Core Data Entities

Based on the components and their data needs, the following core entities are identified:

- **Restaurant**
  - id (UUID)
  - name (String)
  - location (String, optional)
  - created_at (Timestamp)

- **Table**
  - id (UUID)
  - restaurant_id (UUID, FK to Restaurant)
  - table_number (String or Int)
  - created_at (Timestamp)

- **WasteEntry**
  - id (UUID)
  - table_id (UUID, FK to Table)
  - restaurant_id (UUID, FK to Restaurant, for easier queries)
  - timestamp (Timestamp)
  - waste_amount (Float, e.g., kg or %)
  - meal_time (Enum: breakfast, lunch, dinner)
  - predicted_percentage (Float, for ML/AI predictions, optional)
  - report_time (Time, optional, for reporting granularity)

- **User** (if authentication is needed)
  - id (UUID)
  - email (String)
  - role (Enum: admin, staff, etc.)
  - restaurant_id (UUID, FK to Restaurant)
  - created_at (Timestamp)

### Component Data Requirements

- **DashboardStatsWidget, OneInfoWidget, ReportInfosWidget**
  - Need: Aggregated waste data (totals, percentages, comparisons) per day, week, month, table, and meal time.
  - Source: WasteEntry, Table, Restaurant

- **MonthlyWasteChart, WeeklyWasteChart**
  - Need: List of waste values per week/month, grouped by time.
  - Source: WasteEntry (grouped by week/month)

- **WasteTimePieChart**
  - Need: Waste values split by meal time (breakfast, lunch, dinner).
  - Source: WasteEntry (grouped by meal_time)

- **QrResultWidget**
  - Need: Restaurant and table info, fetched by scanning a QR code.
  - Source: Table, Restaurant

### Database Relationships

- A Restaurant has many Tables.
- A Table belongs to a Restaurant.
- A Table has many WasteEntries.
- A WasteEntry belongs to a Table (and, by extension, a Restaurant).
- (Optional) A User belongs to a Restaurant.

### Supabase Setup Plan

When setting up Supabase, you will:
- Create tables for each entity above.
- Use foreign keys to enforce relationships (e.g., table.restaurant_id → restaurant.id).
- Use Supabase Auth for user management (if needed).
- Use Row Level Security (RLS) to restrict data access by user/restaurant.
- Add indexes on timestamp, restaurant_id, and table_id for efficient queries.
- Use Supabase Functions or Triggers for advanced logic (e.g., auto-calculating aggregates).

### Example Table Schemas (Postgres/Supabase)

```sql
-- Restaurant
CREATE TABLE restaurant (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text NOT NULL,
  location text,
  created_at timestamp with time zone DEFAULT now()
);

-- Table
CREATE TABLE table (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  restaurant_id uuid REFERENCES restaurant(id),
  table_number text NOT NULL,
  created_at timestamp with time zone DEFAULT now()
);

-- WasteEntry
CREATE TABLE waste_entry (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  table_id uuid REFERENCES table(id),
  restaurant_id uuid REFERENCES restaurant(id),
  timestamp timestamp with time zone NOT NULL,
  waste_amount float NOT NULL,
  meal_time text CHECK (meal_time IN ('breakfast', 'lunch', 'dinner')),
  predicted_percentage float,
  report_time time,
  created_at timestamp with time zone DEFAULT now()
);

-- User (if needed)
CREATE TABLE app_user (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  email text NOT NULL,
  role text CHECK (role IN ('admin', 'staff')),
  restaurant_id uuid REFERENCES restaurant(id),
  created_at timestamp with time zone DEFAULT now()
);
```

### How Components Will Fetch Data

- **Charts & Stats**: Query `waste_entry` with filters/grouping (by date, meal_time, table, etc.).
- **QR Scan**: Use the scanned code to look up the `table` and its `restaurant`.
- **Reports**: Aggregate and join data from `waste_entry`, `table`, and `restaurant`.

*This overview provides a high-level understanding of the SaveEat Mobile application's structure and features. For detailed implementation specifics, please refer to the individual source files.*

---

## How Data Models Are Used in the Application

### Purpose of Data Models

Data models in the `lib/models` directory serve as the foundation for all structured data in the SaveEat app. They provide a type-safe way to represent, manipulate, and transfer data between the UI, business logic, and backend (Supabase). Each model class mirrors a table in the database and encapsulates both the data and the logic for serialization/deserialization.

### Typical Usage Patterns

#### 1. Fetching Data from Supabase
- When you fetch data from Supabase (using the Supabase Dart client), you receive a JSON map for each record.
- You convert this map into a Dart model using the model's `fromJson` factory constructor.
- Example:
  ```dart
  final response = await supabase.from('table').select().execute();
  final tables = (response.data as List)
      .map((json) => TableModel.fromJson(json))
      .toList();
  ```

#### 2. Sending Data to Supabase
- When you want to insert or update a record, you convert your Dart model to a JSON map using the `toJson` method.
- Example:
  ```dart
  final newTable = TableModel(
    id: 'uuid',
    restaurantId: 'restaurant-uuid',
    tableNumber: '5',
    createdAt: DateTime.now(),
  );
  await supabase.from('table').insert(newTable.toJson()).execute();
  ```

#### 3. Passing Data Between Widgets
- Models are used to pass structured data between screens and widgets, ensuring type safety and clarity.
- Example: When navigating to a detail page, you can pass a `TableModel` or `WasteEntryModel` as an argument.

#### 4. Aggregating and Transforming Data
- For dashboard statistics, charts, and reports, you fetch lists of models and use Dart's collection methods to filter, group, and aggregate data as needed for the UI.

#### 5. Extending Models with Methods
- You can add utility methods to models, such as computed properties (e.g., formatted date strings), or business logic (e.g., isWasteHigh).

### Example: TableModel Usage

```dart
// Fetch tables for a restaurant
final response = await supabase
    .from('table')
    .select()
    .eq('restaurant_id', restaurantId)
    .execute();

final tables = (response.data as List)
    .map((json) => TableModel.fromJson(json))
    .toList();

// Use in UI
ListView.builder(
  itemCount: tables.length,
  itemBuilder: (context, index) {
    final table = tables[index];
    return ListTile(
      title: Text('Table ${table.tableNumber}'),
      subtitle: Text('Created: ${table.createdAt}'),
    );
  },
);
```

### Model Naming Convention

- All model classes are suffixed with `Model` (e.g., `TableModel`, `WasteEntryModel`, `RestaurantModel`, `AppUserModel`) to avoid conflicts with Flutter or Dart core classes and to clarify their purpose.

### Benefits

- **Type Safety:** Prevents runtime errors due to unexpected data types.
- **Code Reuse:** Centralizes data logic (parsing, formatting, etc.) in one place.
- **Maintainability:** Changes to the data structure are made in one place and propagate throughout the app.
- **Integration:** Seamless conversion between Dart objects and JSON for API/database operations.

### Future Extensions

- You can add methods for validation, computed fields, or even static methods for common queries.
- Models can be extended to support relationships (e.g., a `TableModel` with a list of `WasteEntryModel`).
