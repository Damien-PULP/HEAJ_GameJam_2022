// GENERATED AUTOMATICALLY FROM 'Assets/Scripts/Player/Input/PlayerControls.inputactions'

using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine.InputSystem;
using UnityEngine.InputSystem.Utilities;

public class @PlayerControls : IInputActionCollection, IDisposable
{
    public InputActionAsset asset { get; }
    public @PlayerControls()
    {
        asset = InputActionAsset.FromJson(@"{
    ""name"": ""PlayerControls"",
    ""maps"": [
        {
            ""name"": ""PlayerMouvement"",
            ""id"": ""2c396dce-2ce6-49ce-8ef2-21e1a4b3c571"",
            ""actions"": [
                {
                    ""name"": ""Movement"",
                    ""type"": ""PassThrough"",
                    ""id"": ""af06eebf-22d0-4cd9-8e7b-b774554911d5"",
                    ""expectedControlType"": ""Vector2"",
                    ""processors"": """",
                    ""interactions"": """"
                },
                {
                    ""name"": ""Camera"",
                    ""type"": ""PassThrough"",
                    ""id"": ""5dd09900-ef90-47da-8476-f667ec961907"",
                    ""expectedControlType"": ""Vector2"",
                    ""processors"": """",
                    ""interactions"": """"
                }
            ],
            ""bindings"": [
                {
                    ""name"": ""WSAD"",
                    ""id"": ""64330cb2-e43f-46a3-b112-6bde62f6119a"",
                    ""path"": ""2DVector"",
                    ""interactions"": """",
                    ""processors"": """",
                    ""groups"": """",
                    ""action"": ""Movement"",
                    ""isComposite"": true,
                    ""isPartOfComposite"": false
                },
                {
                    ""name"": ""up"",
                    ""id"": ""1b0dafc0-c269-45d2-8179-ad0b501b8548"",
                    ""path"": ""<Keyboard>/w"",
                    ""interactions"": """",
                    ""processors"": """",
                    ""groups"": """",
                    ""action"": ""Movement"",
                    ""isComposite"": false,
                    ""isPartOfComposite"": true
                },
                {
                    ""name"": ""down"",
                    ""id"": ""b714ea85-1c21-4595-b14c-bb87b0c4f3ee"",
                    ""path"": ""<Keyboard>/s"",
                    ""interactions"": """",
                    ""processors"": """",
                    ""groups"": """",
                    ""action"": ""Movement"",
                    ""isComposite"": false,
                    ""isPartOfComposite"": true
                },
                {
                    ""name"": ""left"",
                    ""id"": ""dfaafaa6-5d1c-41f0-af2e-7263c84322d1"",
                    ""path"": ""<Keyboard>/a"",
                    ""interactions"": """",
                    ""processors"": """",
                    ""groups"": """",
                    ""action"": ""Movement"",
                    ""isComposite"": false,
                    ""isPartOfComposite"": true
                },
                {
                    ""name"": ""right"",
                    ""id"": ""1346cb29-a685-4af4-b0bb-76ef9302a435"",
                    ""path"": ""<Keyboard>/d"",
                    ""interactions"": """",
                    ""processors"": """",
                    ""groups"": """",
                    ""action"": ""Movement"",
                    ""isComposite"": false,
                    ""isPartOfComposite"": true
                },
                {
                    ""name"": ""LeftStick"",
                    ""id"": ""5de7e0cb-1a95-403d-b94f-a5059564c582"",
                    ""path"": ""2DVector(mode=2)"",
                    ""interactions"": """",
                    ""processors"": """",
                    ""groups"": """",
                    ""action"": ""Movement"",
                    ""isComposite"": true,
                    ""isPartOfComposite"": false
                },
                {
                    ""name"": ""up"",
                    ""id"": ""f9bf990d-358a-4494-9e02-35bbe8b3e61a"",
                    ""path"": ""<Gamepad>/leftStick/up"",
                    ""interactions"": """",
                    ""processors"": """",
                    ""groups"": """",
                    ""action"": ""Movement"",
                    ""isComposite"": false,
                    ""isPartOfComposite"": true
                },
                {
                    ""name"": ""down"",
                    ""id"": ""78e11498-2600-4833-a3ef-e2d300e15bc9"",
                    ""path"": ""<Gamepad>/leftStick/down"",
                    ""interactions"": """",
                    ""processors"": """",
                    ""groups"": """",
                    ""action"": ""Movement"",
                    ""isComposite"": false,
                    ""isPartOfComposite"": true
                },
                {
                    ""name"": ""left"",
                    ""id"": ""8d342a6d-86ad-4656-82ef-d262235399fb"",
                    ""path"": ""<Gamepad>/leftStick/left"",
                    ""interactions"": """",
                    ""processors"": """",
                    ""groups"": """",
                    ""action"": ""Movement"",
                    ""isComposite"": false,
                    ""isPartOfComposite"": true
                },
                {
                    ""name"": ""right"",
                    ""id"": ""83e909aa-f915-46bc-a720-00e86efd5b7f"",
                    ""path"": ""<Gamepad>/leftStick/right"",
                    ""interactions"": """",
                    ""processors"": """",
                    ""groups"": """",
                    ""action"": ""Movement"",
                    ""isComposite"": false,
                    ""isPartOfComposite"": true
                },
                {
                    ""name"": """",
                    ""id"": ""2249f440-7392-4411-8863-56b2f7f73f81"",
                    ""path"": ""<Mouse>/delta"",
                    ""interactions"": """",
                    ""processors"": """",
                    ""groups"": """",
                    ""action"": ""Camera"",
                    ""isComposite"": false,
                    ""isPartOfComposite"": false
                },
                {
                    ""name"": ""RightStick"",
                    ""id"": ""04b57581-fc0c-46c6-8246-57adc3105c2a"",
                    ""path"": ""2DVector(mode=2)"",
                    ""interactions"": """",
                    ""processors"": """",
                    ""groups"": """",
                    ""action"": ""Camera"",
                    ""isComposite"": true,
                    ""isPartOfComposite"": false
                },
                {
                    ""name"": ""up"",
                    ""id"": ""e7af6490-c5ed-4752-9561-f8e04b0836bc"",
                    ""path"": ""<Gamepad>/rightStick/up"",
                    ""interactions"": """",
                    ""processors"": """",
                    ""groups"": """",
                    ""action"": ""Camera"",
                    ""isComposite"": false,
                    ""isPartOfComposite"": true
                },
                {
                    ""name"": ""down"",
                    ""id"": ""00ad090c-aa58-45e1-83c8-58f7d5af05e3"",
                    ""path"": ""<Gamepad>/rightStick/down"",
                    ""interactions"": """",
                    ""processors"": """",
                    ""groups"": """",
                    ""action"": ""Camera"",
                    ""isComposite"": false,
                    ""isPartOfComposite"": true
                },
                {
                    ""name"": ""left"",
                    ""id"": ""ad876e45-08d7-4be3-8e4e-464fe9388056"",
                    ""path"": ""<Gamepad>/rightStick/left"",
                    ""interactions"": """",
                    ""processors"": """",
                    ""groups"": """",
                    ""action"": ""Camera"",
                    ""isComposite"": false,
                    ""isPartOfComposite"": true
                },
                {
                    ""name"": ""right"",
                    ""id"": ""6aea2575-03d9-42c7-8c95-0b461e77826e"",
                    ""path"": ""<Gamepad>/rightStick/right"",
                    ""interactions"": """",
                    ""processors"": """",
                    ""groups"": """",
                    ""action"": ""Camera"",
                    ""isComposite"": false,
                    ""isPartOfComposite"": true
                }
            ]
        },
        {
            ""name"": ""PlayerActions"",
            ""id"": ""44c2ffd5-af07-43ea-a9be-41a2334d86e1"",
            ""actions"": [
                {
                    ""name"": ""B"",
                    ""type"": ""Button"",
                    ""id"": ""6dbfaa0f-d04e-4d72-bb54-c0aa74a236b5"",
                    ""expectedControlType"": ""Button"",
                    ""processors"": """",
                    ""interactions"": """"
                },
                {
                    ""name"": ""Drop"",
                    ""type"": ""Button"",
                    ""id"": ""8e0e6a1a-b82e-474f-9008-e0a0fd9c9964"",
                    ""expectedControlType"": ""Button"",
                    ""processors"": """",
                    ""interactions"": """"
                },
                {
                    ""name"": ""Fire1"",
                    ""type"": ""Button"",
                    ""id"": ""951e6a31-3e1b-40dc-b6dd-1cd0c7052204"",
                    ""expectedControlType"": ""Button"",
                    ""processors"": """",
                    ""interactions"": """"
                },
                {
                    ""name"": ""Fire2"",
                    ""type"": ""Button"",
                    ""id"": ""9109b4f2-fb9e-4da5-8399-04ea30088e2e"",
                    ""expectedControlType"": ""Button"",
                    ""processors"": """",
                    ""interactions"": """"
                }
            ],
            ""bindings"": [
                {
                    ""name"": """",
                    ""id"": ""8a339725-7520-4daf-8ce3-075085c29344"",
                    ""path"": ""<Gamepad>/leftStickPress"",
                    ""interactions"": """",
                    ""processors"": """",
                    ""groups"": """",
                    ""action"": ""B"",
                    ""isComposite"": false,
                    ""isPartOfComposite"": false
                },
                {
                    ""name"": """",
                    ""id"": ""1cae35dc-9f85-4c07-8147-8af080dc72b3"",
                    ""path"": ""<Keyboard>/shift"",
                    ""interactions"": """",
                    ""processors"": """",
                    ""groups"": """",
                    ""action"": ""B"",
                    ""isComposite"": false,
                    ""isPartOfComposite"": false
                },
                {
                    ""name"": """",
                    ""id"": ""fffde7da-fd5c-4d4a-a00e-d41edaecb083"",
                    ""path"": ""<Gamepad>/buttonSouth"",
                    ""interactions"": """",
                    ""processors"": """",
                    ""groups"": """",
                    ""action"": ""Drop"",
                    ""isComposite"": false,
                    ""isPartOfComposite"": false
                },
                {
                    ""name"": """",
                    ""id"": ""f6e87bca-aa5c-455a-88b1-6f409e7e835f"",
                    ""path"": ""<Keyboard>/e"",
                    ""interactions"": """",
                    ""processors"": """",
                    ""groups"": """",
                    ""action"": ""Drop"",
                    ""isComposite"": false,
                    ""isPartOfComposite"": false
                },
                {
                    ""name"": """",
                    ""id"": ""0bb9d22d-c3bf-4c08-a484-a10c849e1fdc"",
                    ""path"": ""<Mouse>/leftButton"",
                    ""interactions"": """",
                    ""processors"": """",
                    ""groups"": """",
                    ""action"": ""Fire1"",
                    ""isComposite"": false,
                    ""isPartOfComposite"": false
                },
                {
                    ""name"": """",
                    ""id"": ""e7d704d2-164d-4d58-9d9b-4c03b2037467"",
                    ""path"": ""<Mouse>/rightButton"",
                    ""interactions"": """",
                    ""processors"": """",
                    ""groups"": """",
                    ""action"": ""Fire2"",
                    ""isComposite"": false,
                    ""isPartOfComposite"": false
                }
            ]
        }
    ],
    ""controlSchemes"": []
}");
        // PlayerMouvement
        m_PlayerMouvement = asset.FindActionMap("PlayerMouvement", throwIfNotFound: true);
        m_PlayerMouvement_Movement = m_PlayerMouvement.FindAction("Movement", throwIfNotFound: true);
        m_PlayerMouvement_Camera = m_PlayerMouvement.FindAction("Camera", throwIfNotFound: true);
        // PlayerActions
        m_PlayerActions = asset.FindActionMap("PlayerActions", throwIfNotFound: true);
        m_PlayerActions_B = m_PlayerActions.FindAction("B", throwIfNotFound: true);
        m_PlayerActions_Drop = m_PlayerActions.FindAction("Drop", throwIfNotFound: true);
        m_PlayerActions_Fire1 = m_PlayerActions.FindAction("Fire1", throwIfNotFound: true);
        m_PlayerActions_Fire2 = m_PlayerActions.FindAction("Fire2", throwIfNotFound: true);
    }

    public void Dispose()
    {
        UnityEngine.Object.Destroy(asset);
    }

    public InputBinding? bindingMask
    {
        get => asset.bindingMask;
        set => asset.bindingMask = value;
    }

    public ReadOnlyArray<InputDevice>? devices
    {
        get => asset.devices;
        set => asset.devices = value;
    }

    public ReadOnlyArray<InputControlScheme> controlSchemes => asset.controlSchemes;

    public bool Contains(InputAction action)
    {
        return asset.Contains(action);
    }

    public IEnumerator<InputAction> GetEnumerator()
    {
        return asset.GetEnumerator();
    }

    IEnumerator IEnumerable.GetEnumerator()
    {
        return GetEnumerator();
    }

    public void Enable()
    {
        asset.Enable();
    }

    public void Disable()
    {
        asset.Disable();
    }

    // PlayerMouvement
    private readonly InputActionMap m_PlayerMouvement;
    private IPlayerMouvementActions m_PlayerMouvementActionsCallbackInterface;
    private readonly InputAction m_PlayerMouvement_Movement;
    private readonly InputAction m_PlayerMouvement_Camera;
    public struct PlayerMouvementActions
    {
        private @PlayerControls m_Wrapper;
        public PlayerMouvementActions(@PlayerControls wrapper) { m_Wrapper = wrapper; }
        public InputAction @Movement => m_Wrapper.m_PlayerMouvement_Movement;
        public InputAction @Camera => m_Wrapper.m_PlayerMouvement_Camera;
        public InputActionMap Get() { return m_Wrapper.m_PlayerMouvement; }
        public void Enable() { Get().Enable(); }
        public void Disable() { Get().Disable(); }
        public bool enabled => Get().enabled;
        public static implicit operator InputActionMap(PlayerMouvementActions set) { return set.Get(); }
        public void SetCallbacks(IPlayerMouvementActions instance)
        {
            if (m_Wrapper.m_PlayerMouvementActionsCallbackInterface != null)
            {
                @Movement.started -= m_Wrapper.m_PlayerMouvementActionsCallbackInterface.OnMovement;
                @Movement.performed -= m_Wrapper.m_PlayerMouvementActionsCallbackInterface.OnMovement;
                @Movement.canceled -= m_Wrapper.m_PlayerMouvementActionsCallbackInterface.OnMovement;
                @Camera.started -= m_Wrapper.m_PlayerMouvementActionsCallbackInterface.OnCamera;
                @Camera.performed -= m_Wrapper.m_PlayerMouvementActionsCallbackInterface.OnCamera;
                @Camera.canceled -= m_Wrapper.m_PlayerMouvementActionsCallbackInterface.OnCamera;
            }
            m_Wrapper.m_PlayerMouvementActionsCallbackInterface = instance;
            if (instance != null)
            {
                @Movement.started += instance.OnMovement;
                @Movement.performed += instance.OnMovement;
                @Movement.canceled += instance.OnMovement;
                @Camera.started += instance.OnCamera;
                @Camera.performed += instance.OnCamera;
                @Camera.canceled += instance.OnCamera;
            }
        }
    }
    public PlayerMouvementActions @PlayerMouvement => new PlayerMouvementActions(this);

    // PlayerActions
    private readonly InputActionMap m_PlayerActions;
    private IPlayerActionsActions m_PlayerActionsActionsCallbackInterface;
    private readonly InputAction m_PlayerActions_B;
    private readonly InputAction m_PlayerActions_Drop;
    private readonly InputAction m_PlayerActions_Fire1;
    private readonly InputAction m_PlayerActions_Fire2;
    public struct PlayerActionsActions
    {
        private @PlayerControls m_Wrapper;
        public PlayerActionsActions(@PlayerControls wrapper) { m_Wrapper = wrapper; }
        public InputAction @B => m_Wrapper.m_PlayerActions_B;
        public InputAction @Drop => m_Wrapper.m_PlayerActions_Drop;
        public InputAction @Fire1 => m_Wrapper.m_PlayerActions_Fire1;
        public InputAction @Fire2 => m_Wrapper.m_PlayerActions_Fire2;
        public InputActionMap Get() { return m_Wrapper.m_PlayerActions; }
        public void Enable() { Get().Enable(); }
        public void Disable() { Get().Disable(); }
        public bool enabled => Get().enabled;
        public static implicit operator InputActionMap(PlayerActionsActions set) { return set.Get(); }
        public void SetCallbacks(IPlayerActionsActions instance)
        {
            if (m_Wrapper.m_PlayerActionsActionsCallbackInterface != null)
            {
                @B.started -= m_Wrapper.m_PlayerActionsActionsCallbackInterface.OnB;
                @B.performed -= m_Wrapper.m_PlayerActionsActionsCallbackInterface.OnB;
                @B.canceled -= m_Wrapper.m_PlayerActionsActionsCallbackInterface.OnB;
                @Drop.started -= m_Wrapper.m_PlayerActionsActionsCallbackInterface.OnDrop;
                @Drop.performed -= m_Wrapper.m_PlayerActionsActionsCallbackInterface.OnDrop;
                @Drop.canceled -= m_Wrapper.m_PlayerActionsActionsCallbackInterface.OnDrop;
                @Fire1.started -= m_Wrapper.m_PlayerActionsActionsCallbackInterface.OnFire1;
                @Fire1.performed -= m_Wrapper.m_PlayerActionsActionsCallbackInterface.OnFire1;
                @Fire1.canceled -= m_Wrapper.m_PlayerActionsActionsCallbackInterface.OnFire1;
                @Fire2.started -= m_Wrapper.m_PlayerActionsActionsCallbackInterface.OnFire2;
                @Fire2.performed -= m_Wrapper.m_PlayerActionsActionsCallbackInterface.OnFire2;
                @Fire2.canceled -= m_Wrapper.m_PlayerActionsActionsCallbackInterface.OnFire2;
            }
            m_Wrapper.m_PlayerActionsActionsCallbackInterface = instance;
            if (instance != null)
            {
                @B.started += instance.OnB;
                @B.performed += instance.OnB;
                @B.canceled += instance.OnB;
                @Drop.started += instance.OnDrop;
                @Drop.performed += instance.OnDrop;
                @Drop.canceled += instance.OnDrop;
                @Fire1.started += instance.OnFire1;
                @Fire1.performed += instance.OnFire1;
                @Fire1.canceled += instance.OnFire1;
                @Fire2.started += instance.OnFire2;
                @Fire2.performed += instance.OnFire2;
                @Fire2.canceled += instance.OnFire2;
            }
        }
    }
    public PlayerActionsActions @PlayerActions => new PlayerActionsActions(this);
    public interface IPlayerMouvementActions
    {
        void OnMovement(InputAction.CallbackContext context);
        void OnCamera(InputAction.CallbackContext context);
    }
    public interface IPlayerActionsActions
    {
        void OnB(InputAction.CallbackContext context);
        void OnDrop(InputAction.CallbackContext context);
        void OnFire1(InputAction.CallbackContext context);
        void OnFire2(InputAction.CallbackContext context);
    }
}
