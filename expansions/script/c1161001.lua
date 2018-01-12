--梦游仙境·睡鼠
function c1161001.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_POSITION+CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c1161001.con1)
	e1:SetTarget(c1161001.tg1)
	e1:SetOperation(c1161001.op1)
	c:RegisterEffect(e1)   
--  
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_PRE_BATTLE_DAMAGE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,1161001)
	e2:SetCondition(c1161001.con2)
	e2:SetOperation(c1161001.op2)
	c:RegisterEffect(e2)
--
end
--
function c1161001.cfilter1(c)
	return c:IsFaceup() and c:GetLevel()==1
end
function c1161001.con1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c1161001.cfilter1,tp,LOCATION_MZONE,0,1,nil)
end
--
function c1161001.tfilter1(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER)
end
function c1161001.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(c1161001.tfilter1,tp,0,LOCATION_MZONE,1,nil) end
end
--
function c1161001.ofilter1(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER) and c:IsType(TYPE_EFFECT) and not c:IsCanTurnSet()
end
function c1161001.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local gn=Group.CreateGroup()
	local num=0
	local g=Duel.GetMatchingGroup(c1161001.tfilter1,tp,0,LOCATION_MZONE,nil)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		while tc do
			if Duel.TossCoin(tp,1)==0 and tc:IsCanTurnSet() then
				gn:AddCard(tc)
			end
			tc=g:GetNext()
		end
		if gn:GetCount()>0 then
			num=Duel.ChangePosition(gn,POS_FACEDOWN_DEFENSE)
		end
		if num==0 then
			local sg=Duel.GetMatchingGroup(c1161001.ofilter1,tp,0,LOCATION_MZONE,nil)
			if sg:GetCount()>0 then
				local sc=sg:GetFirst()
				while sc do
					if not sc:IsDisabled() then
						local e1_1=Effect.CreateEffect(c)
						e1_1:SetType(EFFECT_TYPE_SINGLE)
						e1_1:SetCode(EFFECT_DISABLE)
						e1_1:SetReset(RESET_EVENT+0xfe0000)
						sc:RegisterEffect(e1_1)
						local e1_2=Effect.CreateEffect(c)
						e1_2:SetType(EFFECT_TYPE_SINGLE)
						e1_2:SetCode(EFFECT_DISABLE_EFFECT)
						e1_2:SetReset(RESET_EVENT+0xfe0000)
						sc:RegisterEffect(e1_2)
					end
					local sc=sg:GetNext()
				end
			end
		end
	end
end
--
function c1161001.con2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetBattleDamage(tp)>0
end
--
function c1161001.op2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.SelectYesNo(tp,aux.Stringid(1161001,0)) then
		Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_EFFECT)
		Duel.ShuffleDeck(tp)
		local num=Duel.GetBattleDamage(tp)
		local lp=Duel.GetLP(tp)
		Duel.SetLP(tp,lp-num)
		Duel.BreakEffect()
		Duel.ChangeBattleDamage(tp,0)
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end
--