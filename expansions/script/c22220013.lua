--神灵凭依的的白沢球
function c22220013.initial_effect(c)
	c:SetUniqueOnField(1,1,22220013)
	c:EnableReviveLimit()
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.FALSE)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(c22220013.sprcon)
	c:RegisterEffect(e2)
	--battle
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22220013,0))
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_BATTLE_START)
	e1:SetTarget(c22220013.target)
	e1:SetOperation(c22220013.operation)
	c:RegisterEffect(e1)
	--must attack
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_MUST_ATTACK)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(0,LOCATION_MZONE)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_MUST_ATTACK_MONSTER)
	c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_MUST_BE_ATTACKED)
	e6:SetValue(1)
	c:RegisterEffect(e6)
end
function c22220013.sprfilter(c)
	return c:IsSetCard(0x50f) and c:IsType(TYPE_TUNER) and c:IsType(TYPE_SYNCHRO) and c:IsFaceup()
end
function c22220013.sprcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c22220013.sprfilter,c:GetControler(),LOCATION_MZONE,0,1,nil)
end
function c22220013.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	if chk==0 then return bc end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,bc,1,0,0)
end
function c22220013.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	if bc:IsRelateToBattle() then
		if Duel.Destroy(bc,REASON_EFFECT)>0 then
			Duel.BreakEffect()
			if not (c:IsRelateToBattle() and c:IsFaceup()) then return end
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			e1:SetRange(LOCATION_MZONE)
			e1:SetValue(c:GetAttack())
			c:RegisterEffect(e1)
			c:CopyEffect(bc:GetOriginalCode(),RESET_EVENT+0x1fe0000,0)
		end
	end
end