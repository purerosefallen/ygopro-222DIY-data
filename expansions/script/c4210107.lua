--命中注定般相遇的莉昂
function c4210107.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(4210107,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetTarget(c4210107.target)
	e1:SetOperation(c4210107.operation)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,4210107)
	e2:SetCost(c4210107.cost)
	e2:SetTarget(c4210107.tg)
	e2:SetOperation(c4210107.op)
	c:RegisterEffect(e2)
end
function c4210107.filter(c)
	return c:IsSetCard(0xa2c) and c:IsType(TYPE_MONSTER) and not c:IsPublic() 
end
function c4210107.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp)
		and Duel.IsExistingMatchingCard(c4210107.filter,tp,LOCATION_HAND,0,1,nil) end
	Duel.SetTargetPlayer(tp)
end
function c4210107.operation(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	Duel.Hint(HINT_SELECTMSG,p,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(p,c4210107.filter,p,LOCATION_HAND,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.ConfirmCards(1-p,g)
		Duel.ShuffleHand(p)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetTargetRange(LOCATION_MZONE,0)
		e1:SetTarget(function(e,c)return c:IsSetCard(0xa2c)end)
		e1:SetValue(300)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	end
end
function c4210107.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c4210107.filter,tp,LOCATION_HAND,0,1,nil) end
	Duel.SendtoHand(e:GetHandler(),nil,REASON_COST)
end
function c4210107.matfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:IsSetCard(0xa2c)
end
function c4210107.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c4210107.matfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c4210107.matfilter,tp,LOCATION_MZONE,0,1,nil) 
		and Duel.IsExistingTarget(c4210107.filter,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c4210107.matfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c4210107.op(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.SelectMatchingCard(tp,function(c)return c:IsSetCard(0xa2c) and c:IsType(TYPE_MONSTER) end,tp,LOCATION_HAND,0,1,1,nil)
	local tc=Duel.GetFirstTarget()
	if g:GetCount()>0 and not tc:IsImmuneToEffect(e) then
		Duel.Overlay(tc,g)
	end
end