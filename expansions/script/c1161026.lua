--歌姬·克莉丝汀
function c1161026.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(1161026,0))
	e1:SetCategory(CATEGORY_POSITION)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c1161026.cost1)
	e1:SetOperation(c1161026.op1)
	c:RegisterEffect(e1)
--  
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_REMAIN_FIELD)
	c:RegisterEffect(e2)
--
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_DRAW)
	e3:SetRange(LOCATION_HAND)
	e3:SetCost(c1161026.cost3)
	e3:SetCondition(c1161026.con3)
	e3:SetOperation(c1161026.op3)
	c:RegisterEffect(e3)
--
end
--
function c1161026.cfilter1(c)
	return c:GetLevel()==1 and c:IsAbleToRemoveAsCost()
end
function c1161026.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c1161026.cfilter1,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c1161026.cfilter1,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
--
function c1161026.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1_1=Effect.CreateEffect(c)
	e1_1:SetType(EFFECT_TYPE_FIELD)
	e1_1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1_1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1_1:SetRange(LOCATION_ONFIELD)
	e1_1:SetTargetRange(0,1)
	e1_1:SetCondition(c1161026.con1_1)
	e1_1:SetValue(c1161026.val1_1)
	e1_1:SetReset(RESET_EVENT+0x1fe0000)
	c:RegisterEffect(e1_1)
end
function c1161026.con1_1(e)
	return Duel.GetTurnPlayer()==e:GetHandler():GetControler()
end
function c1161026.cfilter1_1(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER)
end
function c1161026.val1_1(e,re)
	local rc=re:GetHandler()
	local g=Duel.GetMatchingGroup(c1161026.cfilter1_1,e:GetHandler():GetControler(),LOCATION_MZONE,0,nil)
	local num=0
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		while tc do
			if rc:IsAttribute(tc:GetAttribute()) then
				num=1
			end
			tc=g:GetNext()
		end
	end
	return re:IsActiveType(TYPE_MONSTER) and num==1 and not rc:IsImmuneToEffect(e)
end
--
function c1161026.con3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return Duel.GetCurrentPhase()==PHASE_DRAW and c:IsReason(REASON_RULE)
end
--
function c1161026.cost3(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return not c:IsPublic() end
	local e3_3=Effect.CreateEffect(c)
	e3_3:SetType(EFFECT_TYPE_SINGLE)
	e3_3:SetCode(EFFECT_PUBLIC)
	e3_3:SetReset(RESET_EVENT+0x1fe0000)
	c:RegisterEffect(e3_3)
end
--
function c1161026.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e3_1=Effect.CreateEffect(c)
	e3_1:SetDescription(aux.Stringid(1161026,2))
	e3_1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3_1:SetType(EVENT_FREE_CHAIN+EFFECT_TYPE_CONTINUOUS)
	e3_1:SetRange(LOCATION_HAND)
	e3_1:SetReset(RESET_EVENT+0x1fe0000)
	e3_1:SetTarget(c1161026.tg3_1)
	e3_1:SetOperation(c1161026.op3_1)
	c:RegisterEffect(e3_1)   
--
	local e3_2=Effect.CreateEffect(c)
	e3_2:SetDescription(aux.Stringid(1161026,3))
	e3_2:SetCategory(CATEGORY_REMOVE)
	e3_2:SetType(EFFECT_TYPE_IGNITION)
	e3_2:SetRange(LOCATION_HAND)
	e3_2:SetProperty(EFFECT_FLAG_NO_TURN_RESET+EFFECT_FLAG_CARD_TARGET)
	e3_2:SetCountLimit(1)
	e3_2:SetReset(RESET_EVENT+0x1fe0000)
	e3_2:SetTarget(c1161026.tg3_2)
	e3_2:SetOperation(c1161026.op3_2)
	c:RegisterEffect(e3_2)
--
end
--
function c1161026.tg3_1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsPlayerCanSpecialSummonMonster(tp,c:GetCode(),nil,0x11,0,0,1,0,0,POS_FACEUP) and Duel.GetTurnPlayer()==tp and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
end
function c1161026.op3_1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	c:AddMonsterAttribute(TYPE_NORMAL,0,0,1,0,0)
	Duel.SpecialSummonStep(c,0,tp,tp,true,false,POS_FACEUP)
	c:AddMonsterAttributeComplete()
	local e3_1_1=Effect.CreateEffect(c)
	e3_1_1:SetType(EFFECT_TYPE_SINGLE)
	e3_1_1:SetCode(EFFECT_REMOVE_RACE)
	e3_1_1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3_1_1:SetValue(RACE_ALL)
	e3_1_1:SetReset(RESET_EVENT+0x1fe0000)
	c:RegisterEffect(e3_1_1,true)
	local e3_1_2=e3_1_1:Clone()
	e3_1_2:SetCode(EFFECT_REMOVE_ATTRIBUTE)
	e3_1_2:SetValue(0xff)
	c:RegisterEffect(e3_1_2,true)
	local e3_1_3=e3_1_1:Clone()
	e3_1_3:SetCode(EFFECT_SET_BASE_ATTACK)
	e3_1_3:SetValue(0)
	c:RegisterEffect(e3_1_3,true)
	local e3_1_4=e3_1_1:Clone()
	e3_1_4:SetCode(EFFECT_SET_BASE_DEFENSE)
	e3_1_4:SetValue(0)
	c:RegisterEffect(e3_1_4,true)
	Duel.SpecialSummonComplete()
--
	local e3_1_5=Effect.CreateEffect(c)
	e3_1_5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3_1_5:SetCode(EVENT_DAMAGE)
	e3_1_5:SetCondition(c1161026.con3_1_5)
	e3_1_5:SetOperation(c1161026.op3_1_5)
	e3_1_5:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e3_1_5,tp)
--
	local e3_1_6=Effect.CreateEffect(c)
	e3_1_6:SetType(EFFECT_TYPE_SINGLE)
	e3_1_6:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
	e3_1_6:SetValue(LOCATION_HAND)
	e3_1_6:SetReset(RESET_EVENT+0x1fe0000)
	c:RegisterEffect(e3_1_6)
--
end
--
function c1161026.con3_1_5(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and (bit.band(r,REASON_BATTLE)~=0 or bit.band(r,REASON_EFFECT)~=0)
end
--
function c1161026.op3_1_5(e,tp,eg,ep,ev,re,r,rp)
	local lp=Duel.GetLP(1-tp)
	Duel.SetLP(1-tp,lp-ev)
end
--
function c1161026.tfilter3_2(c,tp)
	return c:IsAbleToRemove() and c:IsType(TYPE_MONSTER) and c:GetLevel()==1 and c1161026.check3_2(c,tp)
end
function c1161026.tfilter3_2_1(c,tc)
	return c:IsAbleToRemove() and c:IsType(TYPE_MONSTER) and c:IsAttribute(tc:GetAttribute())
end
function c1161026.tg3_2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c1161026.tfilter3_2,tp,LOCATION_GRAVE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g1=Duel.SelectTarget(tp,c1161026.tfilter3_2,tp,LOCATION_GRAVE,0,1,1,nil,tp)
	local tc=g1:GetFirst()
	local g2=Duel.SelectTarget(tp,c1161026.tfilter3_2_1,tp,0,LOCATION_MZONE,1,1,nil,tc)
	g1:Merge(g2)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g1,2,0,LOCATION_GRAVE+LOCATION_MZONE)
end
function c1161026.op3_2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tg=g:Filter(Card.IsRelateToEffect,nil,e)
	if tg:GetCount()>0 then
		Duel.Remove(tg,POS_FACEUP,REASON_EFFECT)
	end
end
--
function c1161026.cfilter3_2(c)
	return c:IsAbleToRemove() and c:IsFaceup()
end
function c1161026.check3_2(c,tp)
	local g=Duel.GetMatchingGroup(c1161026.cfilter3_2,tp,0,LOCATION_MZONE,nil)
	local num=0
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		while tc do
			if tc:IsAttribute(c:GetAttribute()) then
				num=1
			end
			tc=g:GetNext()
		end
	end
	return num==1
end
--
