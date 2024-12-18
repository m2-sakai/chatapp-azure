import { ChatMessage } from '../model/ChatMessage';
import { API_ROUTES } from './route';

export async function fetchToken(): Promise<string> {
  const response = await fetch(API_ROUTES.GET_TOKEN);

  if (!response.ok) {
    const errorMessage = await response.text();
    throw new Error(`Failed to fetch token: ${response.status} - ${errorMessage}`);
  }

  const { accessToken } = await response.json();
  return accessToken;
}

export async function fetchChatList(): Promise<ChatMessage[]> {
  const response = await fetch(API_ROUTES.LIST_CHAT);

  if (!response.ok) {
    const errorMessage = await response.text();
    throw new Error(`Failed to fetch token: ${response.status} - ${errorMessage}`);
  }

  const chatMessages = await response.json();
  return chatMessages;
}
