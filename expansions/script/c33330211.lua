local m=33330211
local cm=_G["c"..m]
cm.name="境界交错 星花起舞"
--配 置 信 息
cm.set=0x55a	--字 段
cm.IsMirrorCross=true   --内 置 字 段

function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	--Immune
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(cm.etarget)
	e2:SetValue(cm.efilter)
	c:RegisterEffect(e2)
end
function cm.isset(c)
	return c:IsSetCard(cm.set) or c.IsMirrorCross
end
--Activate
function cm.filter(c)
	return cm.isset(c) and (c:IsAbleToHand() or c:IsAbleToGrave())
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,1))
	local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_DECK,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		local b1=tc:IsAbleToGrave()
		local b2=tc:IsAbleToHand()
		if b1 and (not b2 or Duel.SelectYesNo(tp,aux.Stringid(m,2))) then
			Duel.SendtoGrave(tc,REASON_EFFECT)
		else
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
		end
	end
end
--Immune
function cm.etarget(e,c)
	return c:IsFaceup() and cm.isset(c)
end
function cm.efilter(e,re)
	return not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET)
end