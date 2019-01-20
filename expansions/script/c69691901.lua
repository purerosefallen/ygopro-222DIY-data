--探索安戈洛
local m=69691901
local cm=_G["c"..m]
function cm.initial_effect(c)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.operation)
	c:RegisterEffect(e1)
end
function cm.filter(c,rac)
	return c:IsRace(rac) and c:IsAbleToHand()
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0 end
	local rac=Duel.AnnounceRace(tp,1,RACE_ALL)
	e:SetLabel(rac)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local rac=e:GetLabel()
	local num=0
	local g=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_DECK,0,nil,rac)
	if g:GetCount()<1 then Duel.Hint(HINT_MESSAGE,tp,aux.Stringid(m,1)) return end
	if g:GetCount()>3 then num=3 else num=g:GetCount() end
	local rg=g:RandomSelect(tp,num)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local sg=rg:Select(tp,1,1,nil)
	if sg:GetCount()>0 then
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end





