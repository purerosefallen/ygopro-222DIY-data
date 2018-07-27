--兔·兔
function c11200022.initial_effect(c)
--
	c:EnableReviveLimit()
	aux.AddFusionProcCode2(c,11200019,11200065,true,true)
--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DICE+CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE+CATEGORY_DAMAGE+CATEGORY_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,11200022)
	e1:SetCondition(c11200022.con1)
	e1:SetTarget(c11200022.tg1)
	e1:SetOperation(c11200022.op1)
	c:RegisterEffect(e1)
--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCode(EFFECT_ADD_CODE)
	e2:SetValue(11200065)
	c:RegisterEffect(e2)
--
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetCode(EFFECT_CHANGE_CODE)
	e3:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
	e3:SetValue(11200019)
	c:RegisterEffect(e3)
--
end
--
function c11200022.con1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return bit.band(c:GetSummonType(),SUMMON_TYPE_FUSION)~=0
		and c:GetMaterialCount()>0
end
--
function c11200022.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil)
		and Duel.IsExistingMatchingCard(Card.IsDestructable,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DICE,nil,0,tp,1)
end
--
function c11200022.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local dc=Duel.TossDice(tp,1)
	if dc==1 or dc==2 or dc==3 then
		if c:IsFacedown() then return end
		if not c:IsRelateToEffect(e) then return end
		local e1_1=Effect.CreateEffect(c)
		e1_1:SetType(EFFECT_TYPE_SINGLE)
		e1_1:SetCode(EFFECT_UPDATE_ATTACK)
		e1_1:SetValue(dc*300)
		e1_1:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e1_1)
		local sg=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
		local sc=sg:GetFirst()
		while sc do
			local e1_2=Effect.CreateEffect(c)
			e1_2:SetType(EFFECT_TYPE_SINGLE)
			e1_2:SetCode(EFFECT_UPDATE_ATTACK)
			e1_2:SetValue(-dc*300)
			e1_2:SetReset(RESET_EVENT+0x1fe0000)
			c:RegisterEffect(e1_2)
			local e1_3=Effect.CreateEffect(c)
			e1_3:SetType(EFFECT_TYPE_SINGLE)
			e1_3:SetCode(EFFECT_UPDATE_DEFENSE)
			e1_3:SetValue(-dc*300)
			e1_3:SetReset(RESET_EVENT+0x1fe0000)
			c:RegisterEffect(e1_3)
			sc=sg:GetNext()
		end
	elseif dc==4 or dc==5 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local tg=Duel.SelectMatchingCard(tp,Card.IsDestructable,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
		if tg:GetCount()<1 then return end
		if Duel.Destroy(tg,REASON_EFFECT)<1 then return end
		Duel.Damage(1-tp,dc*200,REASON_EFFECT)
	elseif dc>5 then
		local b1=c:IsFaceup() and c:IsRelateToEffect(e) and Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_ONFIELD,1,nil)
		local b2=Duel.IsExistingMatchingCard(Card.IsDestructable,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
		if not (b1 or b2) then return end
		local off=1
		local ops={}
		local opval={}
		if b1 then
			ops[off]=aux.Stringid(11200022,1)
			opval[off-1]=1
			off=off+1
		end
		if b2 then
			ops[off]=aux.Stringid(11200022,2)
			opval[off-1]=2
			off=off+1
		end
		local op=Duel.SelectOption(tp,table.unpack(ops))
		local sel=opval[op]
		if sel==1 then
			local e1_1=Effect.CreateEffect(c)
			e1_1:SetType(EFFECT_TYPE_SINGLE)
			e1_1:SetCode(EFFECT_UPDATE_ATTACK)
			e1_1:SetValue(dc*300)
			e1_1:SetReset(RESET_EVENT+0x1fe0000)
			c:RegisterEffect(e1_1)
			local sg=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
			local sc=sg:GetFirst()
			while sc do
				local e1_2=Effect.CreateEffect(c)
				e1_2:SetType(EFFECT_TYPE_SINGLE)
				e1_2:SetCode(EFFECT_UPDATE_ATTACK)
				e1_2:SetValue(-dc*300)
				e1_2:SetReset(RESET_EVENT+0x1fe0000)
				c:RegisterEffect(e1_2)
				local e1_3=Effect.CreateEffect(c)
				e1_3:SetType(EFFECT_TYPE_SINGLE)
				e1_3:SetCode(EFFECT_UPDATE_DEFENSE)
				e1_3:SetValue(-dc*300)
				e1_3:SetReset(RESET_EVENT+0x1fe0000)
				c:RegisterEffect(e1_3)
				sc=sg:GetNext()
			end
		else
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
			local tg=Duel.SelectMatchingCard(tp,Card.IsDestructable,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
			if tg:GetCount()<1 then return end
			if Duel.Destroy(tg,REASON_EFFECT)<1 then return end
			Duel.Damage(1-tp,dc*200,REASON_EFFECT)
		end
	else
	end
end
--
