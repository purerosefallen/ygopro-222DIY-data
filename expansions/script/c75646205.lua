--残境 崩坏之塔
function c75646205.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--Equal
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(75646205,0))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCountLimit(2)
	e2:SetCondition(c75646205.eqcon)
	e2:SetTarget(c75646205.eqtg)
	e2:SetOperation(c75646205.eqop)
	c:RegisterEffect(e2)
	--immune effect
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetRange(LOCATION_FZONE)
	e3:SetTargetRange(LOCATION_SZONE,0)
	e3:SetCondition(c75646205.iecon)
	e3:SetTarget(c75646205.ietarget)
	e3:SetValue(c75646205.iefilter)
	c:RegisterEffect(e3)
end
function c75646205.eqcfilter(c,tp)
	return c:IsPreviousPosition(POS_FACEUP) and c:IsPreviousSetCard(0x2c0) and c:IsType(TYPE_EQUIP) and c:IsPreviousLocation(LOCATION_ONFIELD) and c:GetPreviousControler()==tp
end
function c75646205.eqcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c75646205.eqcfilter,1,nil,tp)
end
function c75646205.efilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x2c0)
		and Duel.IsExistingMatchingCard(c75646205.eqfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,c)
end
function c75646205.eqfilter(c,tc)
	return c:IsType(TYPE_EQUIP) and c:IsSetCard(0x2c0) and c:CheckEquipTarget(tc) and (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup())
end
function c75646205.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c75646205.efilter(chkc,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(c75646205.efilter,tp,LOCATION_MZONE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c75646205.efilter,tp,LOCATION_MZONE,0,1,1,nil,tp)
end
function c75646205.eqop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsFacedown() or not tc:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c75646205.eqfilter),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,tc)
	local eq=g:GetFirst()
	if eq then
		Duel.Equip(tp,eq,tc,true)
		eq:AddCounter(0x1b,2)
	end
end
function c75646205.iecfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x2c0) and c:IsControler(tp)
end
function c75646205.iecon(e)
	local tp=e:GetHandlerPlayer()
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	return (a and c75646205.iecfilter(a,tp)) or (d and c75646205.iecfilter(d,tp))
end
function c75646205.ietarget(e,c)
	return c:IsSetCard(0x2c0) and c:IsType(TYPE_EQUIP)
end
function c75646205.iefilter(e,re)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer()
end