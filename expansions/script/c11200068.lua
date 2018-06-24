--兔符『开运大纹』
function c11200068.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_PREDRAW)
	e1:SetRange(LOCATION_HAND)
	e1:SetTarget(c11200068.tg1)
	c:RegisterEffect(e1) 
--
	if not c11200068.global_check then
		c11200068.global_check=true
		c11200068[0]=0
		c11200068[1]=0
		local e0=Effect.GlobalEffect()
		e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e0:SetCode(EVENT_DRAW)
		e0:SetCondition(c11200068.con0)
		e0:SetOperation(c11200068.op0)
		Duel.RegisterEffect(e0,0)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e3:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		e3:SetOperation(c11200068.reset3)
		Duel.RegisterEffect(e3,0)
	end
--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,11200068+EFFECT_COUNT_CODE_OATH)
	e2:SetCondition(c11200068.con2)
	e2:SetTarget(c11200068.tg2)
	e2:SetOperation(c11200068.op2)
	c:RegisterEffect(e2)
--
end
--
function c11200068.reset3(e,tp,eg,ep,ev,re,r,rp)
	c11200068[0]=0
	c11200068[1]=0
end
--
function c11200068.con0(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(r,REASON_RULE)~=0
end
function c11200068.op0(e,tp,eg,ep,ev,re,r,rp)
	c11200068[0]=c11200068[0]+1
	c11200068[1]=c11200068[1]+1
end
--
function c11200068.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return false end
end
--
function c11200068.con2(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return ph==PHASE_DRAW and c11200068[tp]<1
		and Duel.GetTurnPlayer()==tp
end
--
function c11200068.tfilter2(c)
	return c:IsAbleToDeck() and c:IsSetCard(0x133)
end
function c11200068.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local b1=Duel.IsExistingMatchingCard(Card.IsSetCard,tp,LOCATION_DECK,0,1,nil,0x133)
	local b2=Duel.IsExistingMatchingCard(c11200068.tfilter2,tp,LOCATION_GRAVE,0,1,nil)
	if chk==0 then return b1 or b2 end
	local off=1
	local ops={}
	local opval={}
	if b1 then
		ops[off]=aux.Stringid(11200068,0)
		opval[off-1]=1
		off=off+1
	end
	if b2 then
		ops[off]=aux.Stringid(11200068,1)
		opval[off-1]=2
		off=off+1
	end
	local op=Duel.SelectOption(tp,table.unpack(ops))
	local sel=opval[op]
	e:SetLabel(sel)
	if sel==1 then
	else
		e:SetCategory(CATEGORY_TODECK)
		Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_GRAVE)
	end
	local sg=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD+LOCATION_HAND,0,nil)
	e:SetLabelObject(sg)
end
--
function c11200068.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local sel=e:GetLabel()
	if sel==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=Duel.SelectMatchingCard(tp,Card.IsSetCard,tp,LOCATION_DECK,0,1,1,nil,0x133)
		if sg:GetCount()>0 then
			local sc=sg:GetFirst()
			Duel.MoveSequence(sc,0)
			Duel.ConfirmDecktop(tp,1)
		end
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=Duel.SelectMatchingCard(tp,c11200068.tfilter2,tp,LOCATION_GRAVE,0,1,1,nil)
		if sg:GetCount()>0 then
			Duel.SendtoDeck(sg,nil,0,REASON_EFFECT)
		end
	end
	local cg=e:GetLabelObject()
	if cg:GetCount()==1 then
		local e2_1=Effect.CreateEffect(c)
		e2_1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e2_1:SetType(EFFECT_TYPE_FIELD)
		e2_1:SetCode(EFFECT_DRAW_COUNT)
		e2_1:SetTargetRange(1,0)
		e2_1:SetValue(2)
		e2_1:SetReset(RESET_PHASE+PHASE_DRAW+RESET_SELF_TURN)
		Duel.RegisterEffect(e2_1,tp)
	end
end
--
