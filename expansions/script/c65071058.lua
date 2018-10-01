--郁蓝创痕
function c65071058.initial_effect(c)
	 --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c65071058.eqtg)
	e1:SetOperation(c65071058.eqop)
	c:RegisterEffect(e1)
	--Equip limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_EQUIP_LIMIT)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_BATTLE_START)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCondition(c65071058.descon)
	e3:SetTarget(c65071058.destg)
	e3:SetOperation(c65071058.desop)
	c:RegisterEffect(e3)
	--negate attack
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetRange(LOCATION_SZONE)
	e4:SetHintTiming(0,TIMING_BATTLE_PHASE)
	e4:SetCondition(c65071058.atkcon)
	e4:SetCost(c65071058.atkcost)
	e4:SetTarget(c65071058.atktg)
	e4:SetOperation(c65071058.atkop)
	c:RegisterEffect(e4)
	--must attack
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_EQUIP)
	e5:SetCode(EFFECT_MUST_ATTACK)
	e5:SetCondition(c65071058.mucon)
	c:RegisterEffect(e5)
end

function c65071058.mufil(c,e)
	return c:GetEquipCount()~=0
end

function c65071058.mucon(e,tp,eg,ep,ev,re,r,rp,chk)
	return Duel.IsExistingMatchingCard(c65071058.mufil,tp,0,LOCATION_MZONE,1,nil,e)
end
function c65071058.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c65071058.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,c,tc)
	end
end

function c65071058.descon(e)
	local tp=e:GetHandler():GetControler()
	local lp1=Duel.GetLP(tp)
	local lp2=Duel.GetLP(1-tp)
	return Duel.GetAttacker()==e:GetHandler():GetEquipTarget() and lp1<=(lp2/2) 
end
function c65071058.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler():GetEquipTarget()
	local tc=Duel.GetAttackTarget()
	if chk==0 then return tc end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,tc,1,0,0)
end
function c65071058.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler():GetEquipTarget()
	local tc=Duel.GetAttackTarget()
	if tc:IsRelateToBattle() then Duel.Destroy(tc,REASON_EFFECT) end
end
function c65071058.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetEquipTarget()==Duel.GetAttackTarget() and e:GetHandler():GetEquipTarget():IsPosition(POS_FACEUP_ATTACK)
end
function c65071058.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetFlagEffect(65071058)==0 end
	e:GetHandler():RegisterFlagEffect(65071058,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_DAMAGE,0,1)
end
function c65071058.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_MZONE,1,nil) end
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_MZONE,1,1,nil)
end
function c65071058.atkop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateAttack()==true then
		Duel.BreakEffect()
		local tc=Duel.GetFirstTarget()
		local c=e:GetHandler():GetEquipTarget()
		if c:IsPosition(POS_FACEUP_ATTACK) and tc:IsLocation(LOCATION_MZONE) and c:IsLocation(LOCATION_MZONE) then
			Duel.CalculateDamage(c,tc)
		end
	end
end