--STSE·全知头骨
function c107898602.initial_effect(c)
	c:EnableReviveLimit()
	--cannot select battle target
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetTargetRange(0,LOCATION_MZONE)
	e3:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e3:SetCondition(c107898602.atkcon)
	e3:SetValue(c107898602.atlimit)
	c:RegisterEffect(e3)
	--no dmg
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_NO_BATTLE_DAMAGE)
	e5:SetRange(LOCATION_GRAVE)
	e5:SetTargetRange(LOCATION_MZONE,0)
	e5:SetValue(1)
	e5:SetTarget(c107898602.abdtg)
	c:RegisterEffect(e5)
	--def down
	local e6=Effect.CreateEffect(c)
	e6:SetCategory(CATEGORY_DEFCHANGE)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e6:SetCode(EVENT_DAMAGE_STEP_END)
	e6:SetRange(LOCATION_GRAVE)
	e6:SetCondition(c107898602.ddcon)
	e6:SetTarget(c107898602.ddtg)
	e6:SetOperation(c107898602.ddop)
	c:RegisterEffect(e6)
	--Pos Change
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD)
	e7:SetCode(EFFECT_SET_POSITION)
	e7:SetRange(LOCATION_GRAVE)
	e7:SetTarget(c107898602.postg)
	e7:SetTargetRange(LOCATION_MZONE,0)
	e7:SetValue(POS_FACEUP_ATTACK)
	c:RegisterEffect(e7)
	local e8=e7:Clone()
	e8:SetCode(EFFECT_CANNOT_CHANGE_POSITION)
	c:RegisterEffect(e8)
	local e9=e7:Clone()
	e9:SetTarget(c107898602.postg2)
	e9:SetValue(POS_FACEUP_DEFENSE)
	c:RegisterEffect(e9)
	local e10=e9:Clone()
	e10:SetCode(EFFECT_CANNOT_CHANGE_POSITION)
	c:RegisterEffect(e10)
end
function c107898602.ddcon(e,tp,eg,ep,ev,re,r,rp)
	local at=Duel.GetAttackTarget()
	return at~=nil and at:IsType(TYPE_TOKEN) and at:IsSetCard(0x575) and bit.band(at:GetBattlePosition(),POS_DEFENSE)~=0
end
function c107898602.ddtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DEFCHANGE,Duel.GetAttacker(),1,0,0)
end
function c107898602.ddop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetAttackTarget()
	local ac=Duel.GetAttacker()
	local acatk=ac:GetAttack()
	if not tc:IsRelateToBattle() then return end
	local predef=tc:GetDefense()
	local e1=Effect.CreateEffect(tc)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_DEFENSE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	e1:SetValue(-acatk)
	tc:RegisterEffect(e1)
	if tc:IsDefense(0) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
function c107898602.postg(e,c)
	return c:IsSetCard(0x575a) or c:IsCode(107898101,107898102,107898103)and c:IsFaceup()
end
function c107898602.postg2(e,c)
	return c:IsSetCard(0x575) and c:GetBaseAttack()==0 and c:IsType(TYPE_TOKEN) and c:IsFaceup()
end
function c107898602.atkfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x575) and c:IsType(TYPE_TOKEN)
end
function c107898602.atkcon(e)
	return Duel.IsExistingMatchingCard(c107898602.atkfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
function c107898602.atlimit(e,c)
	return c:IsFaceup() and c:IsSetCard(0x575) and not c:IsType(TYPE_TOKEN)
end
function c107898602.abdtg(e,c)
	return Duel.GetTurnPlayer()~=e:GetHandlerPlayer() and c:IsSetCard(0x575) and c:IsType(TYPE_TOKEN)
end