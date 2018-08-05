--莉蒂与苏尔的工作室
function c4212319.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c4212319.target)
	e1:SetOperation(c4212319.operation)
	c:RegisterEffect(e1)
	--Activate(effect)
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(4212317,2))
    e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e3:SetProperty(EFFECT_FLAG_DELAY)
    e3:SetCode(EVENT_TO_GRAVE)
    e3:SetCondition(c4212319.con)
    e3:SetTarget(c4212319.target)
    e3:SetOperation(c4212319.operation)
    c:RegisterEffect(e3)
	--equip limit
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_EQUIP_LIMIT)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetValue(c4212319.eqlimit)
	c:RegisterEffect(e4)
end
function c4212319.eqlimit(e,c)
	return c:IsRace(RACE_SPELLCASTER)
end
function c4212319.filter(c)
	return c:IsFaceup() and c:IsRace(RACE_SPELLCASTER)
end
function c4212319.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c4212319.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c4212319.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c4212319.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c4212319.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if e:GetHandler():IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		if Duel.Equip(tp,e:GetHandler(),tc)~=0 then
			--extra attack
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetCode(EVENT_BATTLED)
			e2:SetType(EFFECT_TYPE_QUICK_O)
			e2:SetCountLimit(1)
			e2:SetRange(LOCATION_MZONE)
			e2:SetCondition(c4212319.atkcon)
			e2:SetTarget(c4212319.atktg)
			e2:SetOperation(c4212319.atkop)
			tc:RegisterEffect(e2)
		end		
	end
end
function c4212319.atkcon(e,tp,eg,ep,ev,re,r,rp)
    local ph=Duel.GetCurrentPhase()
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)
end
function c4212319.sfilter(c)
	return c:GetType()==TYPE_SPELL+TYPE_CONTINUOUS
end
function c4212319.atktg(e,tp,eg,ep,ev,re,r,rp,chk)	
	if chk==0 then return Duel.GetAttacker()==e:GetHandler() 
	and Duel.IsExistingMatchingCard(c4212319.sfilter,tp,LOCATION_ONFIELD,0,1,nil) 
	and Duel.GetFlagEffect(tp,4212319)==0 end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_ONFIELD)	
	Duel.RegisterFlagEffect(tp,4212319,RESET_CHAIN,0,1)
end
function c4212319.atkop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c4212319.sfilter,tp,LOCATION_ONFIELD,0,1,1,nil)
	if g:GetCount()==0 then return end
	if Duel.Destroy(g,REASON_EFFECT)~=0 then
	local c=e:GetHandler()
		if c:IsRelateToEffect(e) then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_EXTRA_ATTACK)
			e1:SetValue(Card.GetAttackedCount(c))
			e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			c:RegisterEffect(e1)
		end
	end
end
function c4212319.con(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsPreviousLocation(LOCATION_DECK)
end