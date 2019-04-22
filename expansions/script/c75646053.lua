--德莉莎修女
function c75646053.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x2c0),4,2)
	c:EnableReviveLimit()
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,75646053)
	e2:SetCost(c75646053.thcost)
	e2:SetTarget(c75646053.thtg)
	e2:SetOperation(c75646053.thop)
	c:RegisterEffect(e2)
	c75646053.xyz_effect=e2
	--atk
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x2c0))
	e3:SetValue(c75646053.atkval)
	c:RegisterEffect(e3)
	--act limit
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetCode(EVENT_CHAINING)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(c75646053.chaincon)
	e4:SetOperation(c75646053.chainop)
	c:RegisterEffect(e4)
end
function c75646053.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c75646053.thfilter(c)
	return c:IsSetCard(0x2c0) and c:IsAbleToHand()
end
function c75646053.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c75646053.thfilter,tp,LOCATION_DECK,0,3,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_DECK)
end
function c75646053.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsSetCard,tp,LOCATION_DECK,0,nil,0x2c0)
	if g:GetCount()>=3 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,3,3,nil)
		Duel.ConfirmCards(1-tp,sg)
		Duel.ShuffleDeck(tp)
		local tg=sg:RandomSelect(1-tp,1)
		local tc=tg:GetFirst()
		if tc:IsAbleToHand() then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		end
		Duel.ShuffleDeck(tp)
	end
end
function c75646053.atkfilter(c)
	return c:IsFaceup() and (aux.IsCodeListed(c,75646150) or aux.IsCodeListed(c,75646174))
end
function c75646053.atkval(e,c)
	return Duel.GetMatchingGroupCount(c75646053.atkfilter,c:GetControler(),LOCATION_SZONE,0,nil)*400
end
function c75646053.chaincon(e)
	local ph=Duel.GetCurrentPhase()
	return ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE
end
function c75646053.chainop(e,tp,eg,ep,ev,re,r,rp)
	local es=re:GetHandler()
	if es:IsSetCard(0x2c0) and es:IsType(TYPE_EQUIP) 
		and es:GetEquipTarget()==e:GetHandler() and re:IsActiveType(TYPE_SPELL) and ep==tp then
		if Duel.IsPlayerAffectedByEffect(e:GetHandler():GetControler(),75646210) then
			Duel.SetChainLimit(c75646053.chainlm)
		else
			Duel.SetChainLimit(aux.FALSE)
		end		
	end
end
function c75646053.chainlm(e,rp,tp)
	return tp==rp
end