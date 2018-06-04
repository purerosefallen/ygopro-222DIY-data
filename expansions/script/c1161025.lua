--女仆猫·卡洛儿
function c1161025.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(1161025,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c1161025.tg1)
	e1:SetOperation(c1161025.op1)
	c:RegisterEffect(e1)
--  
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(1161025,1))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_DAMAGE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(c1161025.con2)
	e2:SetOperation(c1161025.op2)
	c:RegisterEffect(e2)
--
end
--
function c1161025.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,564)
	local ac=Duel.AnnounceCard(tp,TYPE_SPELL)
	Duel.SetTargetParam(ac)
	Duel.SetOperationInfo(0,CATEGORY_ANNOUNCE,nil,0,tp,ANNOUNCE_CARD)
end
--
function c1161025.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ac=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	local e1_1=Effect.CreateEffect(c)
	e1_1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1_1:SetCode(EVENT_CHAIN_SOLVED)
	e1_1:SetLabel(ac)
	e1_1:SetCondition(c1161025.con1_1)
	e1_1:SetOperation(c1161025.op1_1)
	e1_1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1_1,tp)
end
--
function c1161025.con1_1(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	return rc:IsStatus(STATUS_LEAVE_CONFIRMED) and rc:IsRelateToEffect(re)
end
function c1161025.op1_1(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	local p=rc:GetControler()
	local ac=e:GetLabel()
	if Duel.GetLocationCount(p,LOCATION_MZONE)>0 and rc:IsCode(ac) and Duel.IsPlayerCanSpecialSummonMonster(p,ac,nil,0x11,0,0,1,0,0,POS_FACEUP) and Duel.SelectYesNo(p,aux.Stringid(1161025,2)) then
		Duel.Hint(HINT_CARD,0,1161025)
		rc:CancelToGrave()
--
		rc:AddMonsterAttribute(TYPE_NORMAL,0,0,1,0,0)
		Duel.SpecialSummonStep(rc,0,p,p,true,false,POS_FACEUP)
		rc:AddMonsterAttributeComplete()
--
		local e1_1_1=Effect.CreateEffect(rc)
		e1_1_1:SetType(EFFECT_TYPE_SINGLE)
		e1_1_1:SetCode(EFFECT_REMOVE_RACE)
		e1_1_1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1_1_1:SetValue(RACE_ALL)
		e1_1_1:SetReset(RESET_EVENT+0x1fe0000)
		rc:RegisterEffect(e1_1_1,true)
		local e1_1_2=e1_1_1:Clone()
		e1_1_2:SetCode(EFFECT_REMOVE_ATTRIBUTE)
		e1_1_2:SetValue(0xff)
		rc:RegisterEffect(e1_1_2,true)
		local e1_1_3=e1_1_1:Clone()
		e1_1_3:SetCode(EFFECT_SET_BASE_ATTACK)
		e1_1_3:SetValue(0)
		rc:RegisterEffect(e1_1_3,true)
		local e1_1_4=e1_1_1:Clone()
		e1_1_4:SetCode(EFFECT_SET_BASE_DEFENSE)
		e1_1_4:SetValue(0)
		rc:RegisterEffect(e1_1_4,true)
--
		Duel.SpecialSummonComplete()
--
		local e1_1_5=Effect.CreateEffect(rc)
		e1_1_5:SetType(EFFECT_TYPE_FIELD)
		e1_1_5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1_1_5:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		e1_1_5:SetReset(RESET_PHASE+PHASE_END)
		e1_1_5:SetTargetRange(1,0)
		e1_1_5:SetTarget(c1161025.tg1_1_5)
		Duel.RegisterEffect(e1_1_5,p)
--
	end
end
--
function c1161025.tg1_1_5(e,c)
	return not (c:GetLevel()==1 or c:IsLocation(LOCATION_EXTRA))
end
--
function c1161025.con2(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp and ((bit.band(r,REASON_BATTLE)~=0 and Duel.GetTurnPlayer()==1-tp) or (bit.band(r,REASON_EFFECT)~=0 and rp==1-tp))
end
--
function c1161025.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsAbleToRemove() and Duel.SelectYesNo(tp,aux.Stringid(1161025,3)) then
		Duel.Remove(c,POS_FACEUP,REASON_EFFECT)
--
		local lp=Duel.GetLP(tp)
--
		if Duel.GetTurnPlayer()==1-tp then
			local e2_1=Effect.CreateEffect(c)
			e2_1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e2_1:SetCode(EVENT_PHASE+PHASE_END)
			e2_1:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN)
			e2_1:SetCountLimit(1)
			e2_1:SetLabel(lp)
			e2_1:SetCondition(c1161025.con2_1)
			e2_1:SetOperation(c1161025.op2_1)
			Duel.RegisterEffect(e2_1,tp)
		else
			local e2_2=Effect.CreateEffect(c)
			e2_2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e2_2:SetCode(EVENT_PHASE+PHASE_END)
			e2_2:SetCountLimit(1)
			e2_2:SetLabel(lp)
			e2_2:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
			e2_2:SetCondition(c1161025.con2_2)
			e2_2:SetOperation(c1161025.op2_2)
			Duel.RegisterEffect(e2_2,tp)
		end
--
	end
end
--
function c1161025.con2_1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c1161025.op2_1(e,tp,eg,ep,ev,re,r,rp)
	local lp=e:GetLabel()
	local c=e:GetHandler()
	local e2_2=Effect.CreateEffect(c)
	e2_2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2_2:SetCode(EVENT_PHASE+PHASE_END)
	e2_2:SetCountLimit(1)
	e2_2:SetLabel(lp)
	e2_2:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
	e2_2:SetCondition(c1161025.con2_2)
	e2_2:SetOperation(c1161025.op2_2)
	Duel.RegisterEffect(e2_2,tp)
end
--
function c1161025.con2_2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==1-tp
end
function c1161025.op2_2(e,tp,eg,ep,ev,re,r,rp)
	local lp=e:GetLabel()
	Duel.SetLP(tp,lp)
end
--