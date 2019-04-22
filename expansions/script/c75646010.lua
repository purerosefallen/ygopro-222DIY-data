--崩坏学园 符华
function c75646010.initial_effect(c)
	--atk
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(1500)
	e1:SetCondition(c75646010.atkcon)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(122520,1))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BATTLE_CONFIRM)
	e2:SetCondition(c75646010.atkcon)
	e2:SetTarget(c75646010.destg)
	e2:SetOperation(c75646010.desop)
	c:RegisterEffect(e2)
	--act limit
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetCode(EVENT_CHAINING)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(c75646010.chaincon)
	e4:SetOperation(c75646010.chainop)
	c:RegisterEffect(e4)
end
function c75646010.atkcon(e)
	local eg=e:GetHandler():GetEquipGroup()
	return eg:GetCount()==0
end
function c75646010.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local t=Duel.GetAttackTarget()
	if chk==0 then return Duel.GetAttacker()==e:GetHandler() and t~=nil end
	Duel.SetTargetCard(t)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,t,1,0,0)
end
function c75646010.desop(e,tp,eg,ep,ev,re,r,rp)
	local t=Duel.GetFirstTarget()
	if t:IsRelateToBattle() then
		Duel.Destroy(t,REASON_EFFECT)
	end
end
function c75646010.chaincon(e)
	local ph=Duel.GetCurrentPhase()
	return ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE
end
function c75646010.chainop(e,tp,eg,ep,ev,re,r,rp)
	local es=re:GetHandler()
	if es:IsSetCard(0x2c0) and es:IsType(TYPE_EQUIP) 
		and es:GetEquipTarget()==e:GetHandler() and re:IsActiveType(TYPE_SPELL) and ep==tp then
		if Duel.IsPlayerAffectedByEffect(e:GetHandler():GetControler(),75646210) then
			Duel.SetChainLimit(c75646010.chainlm)
		else
			Duel.SetChainLimit(aux.FALSE)
		end		
	end
end
function c75646010.chainlm(e,rp,tp)
	return tp==rp
end