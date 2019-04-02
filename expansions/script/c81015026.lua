--一头六臂·北上丽花
require("expansions/script/c81000000")
function c81015026.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,c81015026.matfilter,2,2)
	c:EnableReviveLimit()
	--tograve
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1,81015026)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(Tenka.ReikaCon)
	e1:SetTarget(c81015026.target)
	e1:SetOperation(c81015026.operation)
	c:RegisterEffect(e1)
	--change battle target
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BE_BATTLE_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c81015026.cbcon)
	e2:SetCost(c81015026.cbcost)
	e2:SetTarget(c81015026.cbtg)
	e2:SetOperation(c81015026.cbop)
	c:RegisterEffect(e2)
end
function c81015026.matfilter(c)
	return c:IsLevel(6)
end
function c81015026.cbcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bt=eg:GetFirst()
	return r~=REASON_REPLACE and c~=bt and bt:IsFaceup() and bt:GetControler()==c:GetControler() and bt:IsSetCard(0x81a)
end
function c81015026.cfilter(c)
	return c:GetSequence()<5 and c:IsAbleToGraveAsCost()
end
function c81015026.cbcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c81015026.cfilter,tp,LOCATION_SZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c81015026.cfilter,tp,LOCATION_SZONE,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c81015026.cbtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetAttacker():GetAttackableTarget():IsContains(e:GetHandler()) end
end
function c81015026.cbop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and not Duel.GetAttacker():IsImmuneToEffect(e) then
		Duel.ChangeAttackTarget(c)
	end
end
function c81015026.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDiscardDeck(tp,5)
		and Duel.GetDecktopGroup(tp,5):FilterCount(Card.IsAbleToHand,nil)>0 end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_DECK)
end
function c81015026.filter(c)
	return c:IsSetCard(0x81a) and c:IsAbleToHand()
end
function c81015026.operation(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsPlayerCanDiscardDeck(tp,5) then return end
	Duel.ConfirmDecktop(tp,5)
	local g=Duel.GetDecktopGroup(tp,5)
	if g:GetCount()>0 then
		if g:IsExists(c81015026.filter,1,nil) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local sg=g:FilterSelect(tp,c81015026.filter,1,1,nil)
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
			Duel.ShuffleHand(tp)
			g:Sub(sg)
			Duel.SendtoGrave(g,REASON_EFFECT+REASON_REVEAL)
		else
			Duel.ShuffleDeck(tp)
		end
	end
end
