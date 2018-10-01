--蕾蒂希雅
function c65071067.initial_effect(c)
	--Destroy
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_CHAINING)
	e2:SetCondition(c65071067.recon)
	e2:SetTarget(c65071067.retg)
	e2:SetOperation(c65071067.reop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e3:SetType(EFFECT_TYPE_ACTIVATE)
	e3:SetCode(EVENT_ATTACK_ANNOUNCE)
	e3:SetCondition(c65071067.recon2)
	e3:SetTarget(c65071067.retg2)
	e3:SetOperation(c65071067.reop2)
	c:RegisterEffect(e3)
	--counter
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_COUNTER)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCost(aux.bfgcost)
	e4:SetOperation(c65071067.ctop)
	c:RegisterEffect(e4)
end
function c65071067.recon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttacker():GetCounter(0x10da)~=0
end

function c65071067.retg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetAttacker():IsAbleToRemove() and Duel.IsPlayerCanSpecialSummonMonster(tp,65071152,0,0x4011,2000,2000,6,RACE_FIEND,ATTRIBUTE_DARK) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c65071067.reop2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetAttacker()
	if tc:IsRelateToBattle() then
		if Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)~=0 then
			local token=Duel.CreateToken(tp,65071152)
			Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end

function c65071067.recon(e,tp,eg,ep,ev,re,r,rp)
	return re:GetHandler():IsOnField() and re:IsActiveType(TYPE_MONSTER) and re:GetHandler():GetCounter(0x10da)~=0
end

function c65071067.retg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return re:GetHandler():IsAbleToRemove() and Duel.IsPlayerCanSpecialSummonMonster(tp,65071152,0,0x4011,2000,2000,6,RACE_FIEND,ATTRIBUTE_DARK) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,eg,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c65071067.reop(e,tp,eg,ep,ev,re,r,rp)
	if re:GetHandler():IsRelateToEffect(re) then
		if Duel.Remove(eg,POS_FACEUP,REASON_EFFECT)~=0 then
			local token=Duel.CreateToken(tp,65071152)
			Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
function c65071067.ctop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e0=Effect.CreateEffect(c)
		e0:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e0:SetCode(EVENT_CHAINING)
		e0:SetReset(RESET_PHASE+PHASE_END)
		e0:SetOperation(aux.chainreg)
		Duel.RegisterEffect(e0,tp)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e1:SetCode(EVENT_CHAIN_SOLVED)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetOperation(c65071067.acop)
		Duel.RegisterEffect(e1,tp)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e3:SetCode(EVENT_ATTACK_ANNOUNCE)
		e3:SetReset(RESET_PHASE+PHASE_END)
		e3:SetOperation(c65071067.acop2)
		Duel.RegisterEffect(e3,tp)
end
function c65071067.acop(e,tp,eg,ep,ev,re,r,rp)
	local c=re:GetHandler()
	if re:IsActiveType(TYPE_MONSTER) then
		c:AddCounter(0x10da,1)
	end
end

function c65071067.acop2(e,tp,eg,ep,ev,re,r,rp)
	local c=Duel.GetAttacker()
	c:AddCounter(0x10da,1)
end