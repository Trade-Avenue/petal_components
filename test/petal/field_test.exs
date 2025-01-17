defmodule PetalComponents.FieldTest do
  use ComponentCase
  import PetalComponents.Field

  test "field as text" do
    assigns = %{form: to_form(%{}, as: :user)}

    html =
      rendered_to_string(~H"""
      <.form for={@form}>
        <.field
          field={@form[:name]}
          placeholder="eg. Sally"
          class="!w-max"
          itemid="something"
          value="John"
          help_text="Help text"
          label_class="label-class"
        />
      </.form>
      """)

    assert html =~ "label"
    assert html =~ "Name"
    assert html =~ "input"
    assert html =~ "Sally"
    assert html =~ "user[name]"
    assert html =~ "itemid"
    assert html =~ "something"
    assert html =~ "phx-feedback-for"
    refute html =~ " disabled "
    assert html =~ "pc-text-input"
    assert html =~ "!w-max"
    assert html =~ ~s|value="John"|
    assert html =~ "Help text"
    assert html =~ "label-class"
  end

  test "field as text with field errors" do
    assigns = %{
      field: %Phoenix.HTML.FormField{
        errors: [
          {"can't be blank", [validation: :required]},
          {"too short!", [validation: :length]}
        ],
        name: "name",
        value: "",
        field: :name,
        id: "name",
        form: %Phoenix.HTML.Form{}
      }
    }

    html =
      rendered_to_string(~H"""
      <.field field={@field} />
      """)

    assert html =~ "name"
    assert html =~ "Name"
    assert html =~ "pc-form-field-error"
    assert html =~ html_escape("can't be blank")
    assert html =~ html_escape("too short!")
  end

  test "field as text with custom errors" do
    assigns = %{form: to_form(%{}, as: :user)}

    html =
      rendered_to_string(~H"""
      <.form for={@form}>
        <.field
          label="Name"
          value=""
          name="name"
          errors={[
            "can't be blank",
            "too short!"
          ]}
        />
      </.form>
      """)

    assert html =~ "pc-form-field-error"
    assert html =~ html_escape("can't be blank")
    assert html =~ html_escape("too short!")
  end

  test "field standard inputs" do
    assigns = %{form: to_form(%{}, as: :user)}

    html =
      rendered_to_string(~H"""
      <.form for={@form}>
        <.field field={@form[:name]} type="color" />
        <.field field={@form[:name]} type="date" />
        <.field field={@form[:name]} type="datetime-local" />
        <.field field={@form[:name]} type="email" />
        <.field field={@form[:name]} type="file" />
        <.field field={@form[:name]} type="hidden" />
        <.field field={@form[:name]} type="month" />
        <.field field={@form[:name]} type="number" />
        <.field field={@form[:name]} type="password" />
        <.field field={@form[:name]} type="range" />
        <.field field={@form[:name]} type="search" />
        <.field field={@form[:name]} type="tel" />
        <.field field={@form[:name]} type="text" />
        <.field field={@form[:name]} type="time" />
        <.field field={@form[:name]} type="url" />
        <.field field={@form[:name]} type="week" />
      </.form>
      """)

    assert html =~ "input"
    assert html =~ ~s|type="color"|
    assert html =~ ~s|type="date"|
    assert html =~ ~s|type="datetime-local"|
    assert html =~ ~s|type="email"|
    assert html =~ ~s|type="file"|
    assert html =~ ~s|type="hidden"|
    assert html =~ ~s|type="month"|
    assert html =~ ~s|type="number"|
    assert html =~ ~s|type="password"|
    assert html =~ ~s|type="range"|
    assert html =~ ~s|type="search"|
    assert html =~ ~s|type="tel"|
    assert html =~ ~s|type="text"|
    assert html =~ ~s|type="time"|
    assert html =~ ~s|type="url"|
    assert html =~ ~s|type="week"|
  end

  test "field text disabled" do
    assigns = %{form: to_form(%{}, as: :user)}

    html =
      rendered_to_string(~H"""
      <.form for={@form}>
        <.field disabled field={@form[:name]} />
      </.form>
      """)

    assert html =~ "input"
    assert html =~ "user[name]"
    assert html =~ "disabled"
  end

  test "field checkbox" do
    assigns = %{form: to_form(%{}, as: :user)}

    html =
      rendered_to_string(~H"""
      <.form for={@form}>
        <.field type="checkbox" field={@form[:read_terms]} itemid="something" />
      </.form>
      """)

    assert html =~ "checkbox"
    assert html =~ "user[read_terms]"
    assert html =~ "phx-feedback-for"
    assert html =~ "itemid"

    # It includes a hidden field for when the switch is not checked
    assert html =~ ~s|<input type="hidden" name="user[read_terms]" value="false">|
  end

  test "field select" do
    assigns = %{form: to_form(%{}, as: :user)}

    html =
      rendered_to_string(~H"""
      <.form for={@form}>
        <.field
          type="select"
          class="custom-class"
          field={@form[:role]}
          options={[Admin: "admin", User: "user"]}
          itemid="something"
        />
      </.form>
      """)

    assert html =~ "<select"
    assert html =~ "user[role]"
    assert html =~ "itemid"
    assert html =~ "<option"
    assert html =~ "admin"
    assert html =~ "phx-feedback-for"
    assert html =~ "Admin"
    assert html =~ "custom-class"
  end

  test "field select selected attributes" do
    assigns = %{form: to_form(%{}, as: :user)}

    html =
      rendered_to_string(~H"""
      <.form for={@form}>
        <.field
          type="select"
          class="custom-class"
          field={@form[:role]}
          options={[Admin: "admin", User: "user"]}
          itemid="something"
          selected="admin"
        />
      </.form>
      """)

    assert html =~ "option selected"
  end

  test "field textarea" do
    assigns = %{form: to_form(%{}, as: :user)}

    html =
      rendered_to_string(~H"""
      <.form for={@form}>
        <.field
          class="custom-class"
          type="textarea"
          field={@form[:description]}
          itemid="something"
          placeholder="dummy text"
          rows="8"
        />
      </.form>
      """)

    assert html =~ "<textarea"
    assert html =~ "user[description]"
    assert html =~ "itemid"
    assert html =~ "placeholder"
    assert html =~ "phx-feedback-for"
    assert html =~ "dummy text"
    assert html =~ "custom-class"
    assert html =~ "rows=\"8\""
  end

  test "field checkbox-group" do
    assigns = %{form: to_form(%{}, as: :user)}

    html =
      rendered_to_string(~H"""
      <.form for={@form}>
        <.field
          class="custom-class"
          type="checkbox-group"
          field={@form[:roles]}
          options={[{"Read", "read"}, {"Write", "write"}]}
        />
      </.form>
      """)

    assert html =~ "checkbox"
    assert html =~ "user_roles"
    assert html =~ "user[roles][]"
    assert html =~ "Read"
    assert html =~ "phx-feedback-for"
    assert html =~ "Write"
    refute html =~ " checked "
    assert html =~ "hidden"
    assert html =~ "custom-class"
  end

  test "field checkbox-group disabled_options" do
    assigns = %{form: to_form(%{}, as: :user)}

    html =
      rendered_to_string(~H"""
      <.form for={@form}>
        <.field
          type="checkbox-group"
          field={@form[:roles]}
          options={[{"Option 1", "1"}, {"Option 2", "2"}, {"Option 3", "3"}]}
          disabled_options={["1", "3"]}
        />
      </.form>
      """)

    assert html =~ "disabled"
    count_disabled = length(String.split(html, "disabled")) - 1
    assert count_disabled == 2
  end

  test "field checkbox-group checked" do
    assigns = %{form: to_form(%{}, as: :user)}

    html =
      rendered_to_string(~H"""
      <.form for={@form}>
        <.field
          type="checkbox-group"
          checked={["read"]}
          field={@form[:roles]}
          options={[{"Read", "read"}, {"Write", "write"}]}
        />
      </.form>
      """)

    assert html =~ " checked "

    assigns = %{form: to_form(%{"roles" => ["read"]}, as: :user)}

    html =
      rendered_to_string(~H"""
      <.form for={@form}>
        <.field
          class="custom-class"
          type="checkbox-group"
          field={@form[:roles]}
          options={[{"Read", "read"}, {"Write", "write"}]}
        />
      </.form>
      """)

    assert html =~ " checked "
  end

  test "field checkbox-group group_layout" do
    assigns = %{form: to_form(%{}, as: :user)}

    html =
      rendered_to_string(~H"""
      <.form for={@form}>
        <.field
          type="checkbox-group"
          checked={["read"]}
          field={@form[:roles]}
          group_layout="col"
          options={[{"Read", "read"}, {"Write", "write"}]}
        />
      </.form>
      """)

    assert html =~ "pc-checkbox-group--col"

    html =
      rendered_to_string(~H"""
      <.form for={@form}>
        <.field
          type="checkbox-group"
          checked={["read"]}
          field={@form[:roles]}
          group_layout="row"
          options={[{"Read", "read"}, {"Write", "write"}]}
        />
      </.form>
      """)

    assert html =~ "pc-checkbox-group--row"
  end

  test "field checkbox-group empty options" do
    assigns = %{form: to_form(%{}, as: :user)}

    html =
      rendered_to_string(~H"""
      <.form for={@form}>
        <.field
          type="checkbox-group"
          checked={["read"]}
          field={@form[:roles]}
          options={[]}
          empty_message="No options"
        />
      </.form>
      """)

    assert html =~ "No options"

    assigns = %{form: to_form(%{}, as: :user)}

    html =
      rendered_to_string(~H"""
      <.form for={@form}>
        <.field
          type="checkbox-group"
          checked={["read"]}
          field={@form[:roles]}
          options={[{"Read", "read"}, {"Write", "write"}]}
          empty_message="No options"
        />
      </.form>
      """)

    refute html =~ "No options"
  end

  test "field radio-group" do
    assigns = %{form: to_form(%{}, as: :user)}

    html =
      rendered_to_string(~H"""
      <.form for={@form}>
        <.field
          class="custom-class"
          type="radio-group"
          field={@form[:roles]}
          options={[{"Read", "read"}, {"Write", "write"}]}
        />
      </.form>
      """)

    assert html =~ "radio"
    assert html =~ "user_roles"
    assert html =~ "user[roles]"
    assert html =~ "Read"
    assert html =~ "phx-feedback-for"
    assert html =~ "Write"
    refute html =~ " checked "
    assert html =~ "hidden"
    assert html =~ "custom-class"
  end

  test "field radio-group checked on form field" do
    assigns = %{form: to_form(%{"roles" => "write"}, as: :user)}

    html =
      rendered_to_string(~H"""
      <.form for={@form}>
        <.field
          class="custom-class"
          type="radio-group"
          field={@form[:roles]}
          options={[{"Read", "read"}, {"Write", "write"}]}
        />
      </.form>
      """)

    assert html =~ ~s|value="write" checked|

    # Test when value is an integer
    assigns = %{form: to_form(%{"roles" => 2}, as: :user)}

    html =
      rendered_to_string(~H"""
      <.form for={@form}>
        <.field
          class="custom-class"
          type="radio-group"
          field={@form[:roles]}
          options={[{"Read", "1"}, {"Write", "2"}]}
        />
      </.form>
      """)

    assert html =~ ~s|value="2" checked|
  end

  test "field radio-group checked attr" do
    assigns = %{form: to_form(%{}, as: :user)}

    html =
      rendered_to_string(~H"""
      <.form for={@form}>
        <.field
          class="custom-class"
          type="radio-group"
          field={@form[:roles]}
          checked="write"
          options={[{"Read", "read"}, {"Write", "write"}]}
        />
      </.form>
      """)

    assert html =~ ~s|value="write" checked|
  end

  test "field radio-group empty options" do
    assigns = %{form: to_form(%{}, as: :user)}

    html =
      rendered_to_string(~H"""
      <.form for={@form}>
        <.field
          class="custom-class"
          type="radio-group"
          field={@form[:roles]}
          options={[]}
          empty_message="No options"
        />
      </.form>
      """)

    assert html =~ "No options"

    assigns = %{form: to_form(%{}, as: :user)}

    html =
      rendered_to_string(~H"""
      <.form for={@form}>
        <.field
          class="custom-class"
          type="radio-group"
          field={@form[:roles]}
          options={[{"Read", "read"}, {"Write", "write"}]}
          empty_message="No options"
        />
      </.form>
      """)

    refute html =~ "No options"
  end

  test "field switch" do
    assigns = %{form: to_form(%{}, as: :user)}

    html =
      rendered_to_string(~H"""
      <.form for={@form}>
        <.field type="switch" field={@form[:read_terms]} data-extra="true" />
      </.form>
      """)

    assert html =~ "checkbox"
    assert html =~ "user[read_terms]"
    assert html =~ "phx-feedback-for"
    assert html =~ "data-extra"

    # It includes a hidden field for when the switch is not checked
    assert html =~ ~s|<input type="hidden" name="user[read_terms]" value="false">|
  end

  test "field radio group" do
    assigns = %{form: to_form(%{}, as: :user)}

    html =
      rendered_to_string(~H"""
      <.form for={@form}>
        <.field
          type="radio-group"
          field={@form[:read_terms]}
          options={[{"Read", "read"}, {"Write", "write"}]}
          data-extra="true"
        />
      </.form>
      """)

    assert html =~ "checkbox"
    assert html =~ "user[read_terms]"
    assert html =~ "phx-feedback-for"
    assert html =~ "data-extra"
  end

  test "field_help_text" do
    assigns = %{}

    html =
      rendered_to_string(~H"""
      <.field_help_text help_text="Inline" />
      """)

    assert html =~ "Inline"

    html =
      rendered_to_string(~H"""
      <.field_help_text>Utilising slot</.field_help_text>
      """)

    assert html =~ "Utilising slot"

    html =
      rendered_to_string(~H"""
      <.field_help_text class="mt-1" help_text="Test class" />
      """)

    assert html =~ "Test class"
    assert html =~ "mt-1"

    html =
      rendered_to_string(~H"""
      <.field_help_text />
      """)

    refute html =~ "pc-form-help-text"
  end
end
