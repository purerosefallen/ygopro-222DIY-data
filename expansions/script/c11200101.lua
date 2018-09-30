--失败者
function c11200101.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCode(EFFECT_LPCOST_REPLACE)
	e2:SetCondition(c11200101.lrcon)
	e2:SetOperation(c11200101.lrop)
	c:RegisterEffect(e2)
	--disable attack
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(11200101,0))
	e3:SetCategory(CATEGORY_DAMAGE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCode(EVENT_ATTACK_ANNOUNCE)
	e3:SetCost(c11200101.atkcost)
	e3:SetTarget(c11200101.atktg)
	e3:SetOperation(c11200101.atkop)
	c:RegisterEffect(e3)
end
function c11200101.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
end
function c11200101.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(1000)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,1000)
end
function c11200101.atkop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateAttack() then
	   Duel.Damage(1-tp,1000,REASON_EFFECT)
	end
end
function c11200101.lrcon(e,tp,eg,ep,ev,re,r,rp)
	if not re or not re:IsHasType(0x7e0) then return false end
	local rc=re:GetHandler()
	if not rc:IsType(TYPE_FUSION) or not rc:IsLocation(LOCATION_MZONE) or not rc:IsAttribute(ATTRIBUTE_DARK) or not rc:IsControler(tp) then return false end
	local lp=Duel.GetLP(ep)
	if lp<ev then return false end
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,11200102,0,0x4011,0,0,1,RACE_SPELLCASTER,ATTRIBUTE_DARK,POS_FACEUP_ATTACK)
end
function c11200101.lrop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_CARD,0,11200101)
	local token=Duel.CreateToken(tp,11200102)
	Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP_ATTACK)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	e1:SetValue(1)
	token:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	token:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	token:RegisterEffect(e3)
	local e4=e1:Clone()
	e4:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	token:RegisterEffect(e4)
	local e5=e1:Clone()
	e5:SetCode(EFFECT_MUST_ATTACK)
	token:RegisterEffect(e5)
end