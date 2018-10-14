--炼金工作室-乐园的探索
function c4212309.initial_effect(c)
	--boost
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_FZONE)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0xa25))
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetValue(function(e,c) return Duel.GetMatchingGroupCount(function(c,e) return c:IsSetCard(0xa25) and c:IsFaceup() and c:IsType(TYPE_SPELL) end,c:GetControler(),LOCATION_SZONE,0,nil)*300 end)
	c:RegisterEffect(e1)
	--Activate
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,4212309) 
	e2:SetOperation(c4212309.activate)	
	c:RegisterEffect(e2)
	--Activate(effect)
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_DECKDES)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1) 
	e3:SetTarget(c4212309.tg)
	e3:SetOperation(c4212309.op)
	c:RegisterEffect(e3)	
end
function c4212309.cfilter(c) 
	return c:IsAbleToDeck() and c:IsType(TYPE_SPELL) and c:IsType(TYPE_CONTINUOUS)
end
function c4212309.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsExistingMatchingCard(c4212309.cfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil) then
		if Duel.SelectEffectYesNo(tp,e:GetHandler(),95) then
			local g=Duel.SelectMatchingCard(tp,c4212309.cfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,3,nil,e)
			if g:GetCount()>0 then
				Duel.SendtoDeck(g,nil,2,REASON_EFFECT+REASON_RETURN)
			end
		end
	end
end
function c4212309.exfilter(c)
	return c:IsAbleToHand() and c:IsSetCard(0xa25)
end
function c4212309.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDiscardDeck(tp,3)	end
end
function c4212309.op(e,tp,eg,ep,ev,re,r,rp)	
	if not Duel.IsPlayerCanDiscardDeck(tp,3) then return end
	Duel.ConfirmDecktop(tp,3)
	local g=Duel.GetDecktopGroup(tp,3)
	if g:GetCount()>0 then
		Duel.DisableShuffleCheck()
		if g:IsExists(c4212309.exfilter,1,nil) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local sg=g:FilterSelect(tp,c4212309.exfilter,1,1,nil)
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
			Duel.ShuffleHand(tp)
			g:Sub(sg)
		end
		Duel.SendtoGrave(g,REASON_EFFECT+REASON_REVEAL)
	end
end