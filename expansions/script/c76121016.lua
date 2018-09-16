--鱼锤手波鼠
function c76121016.initial_effect(c)
	--summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(76121016,0))
	e1:SetCategory(CATEGORY_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_HAND)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,0x1c0+TIMING_MAIN_END)
	e1:SetCost(c76121016.sumcost)
	e1:SetTarget(c76121016.sumtg)
	e1:SetOperation(c76121016.sumop)
	c:RegisterEffect(e1)
	--Activate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(76121016,1))
	e2:SetCategory(CATEGORY_POSITION)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetCondition(c76121016.poscon)
	e2:SetCost(c76121016.poscost)
	e2:SetTarget(c76121016.postg)
	e2:SetOperation(c76121016.posop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	local e4=e2:Clone()
	e4:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	e4:SetTarget(c76121016.postg2)
	c:RegisterEffect(e4)
end
function c76121016.cfilter(c)
	return c:IsSetCard(0xea2) and c:IsType(TYPE_TRAP) and c:IsAbleToGraveAsCost()
end
function c76121016.sumcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsPublic() and Duel.IsExistingMatchingCard(c76121016.cfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,tp) and e:GetHandler():GetFlagEffect(76121016)==0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c76121016.cfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,tp)
	Duel.SendtoGrave(g,REASON_COST)
	e:GetHandler():RegisterFlagEffect(76121016,RESET_CHAIN,0,1)
end
function c76121016.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsMSetable(true,nil,0) end
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,e:GetHandler(),1,0,0)
end
function c76121016.sumop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsMSetable(true,nil,0) then
		Duel.MSet(tp,c,true,nil,0)
	end
end
function c76121016.poscon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsFacedown()
end
function c76121016.poscost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.ChangePosition(e:GetHandler(),POS_FACEUP_DEFENSE)
end
function c76121016.posfilter(c,tp)
	return c:IsFaceup() and c:GetSummonPlayer()~=tp and c:IsCanTurnSet()
end
function c76121016.postg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c76121016.posfilter,1,nil,tp) end
	local g=eg:Filter(c76121016.posfilter,nil,tp)
	Duel.SetTargetCard(g)
end
function c76121016.postg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=eg:GetFirst()
	if chk==0 then return rp==1-tp and tc:IsFaceup() and tc:IsCanTurnSet() end
	Duel.SetTargetCard(tc)
end
function c76121016.posop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if Duel.ChangePosition(g,POS_FACEDOWN_DEFENSE)~=0 then
		local og=Duel.GetOperatedGroup()
		local tc=og:GetFirst()
		while tc do
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CANNOT_CHANGE_POSITION)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e1)
			tc=og:GetNext()
		end
	end
end