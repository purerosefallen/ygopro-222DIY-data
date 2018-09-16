--星灵虎
function c69696916.initial_effect(c)
	--spirit return
	aux.EnableSpiritReturn(c,EVENT_SUMMON_SUCCESS,EVENT_FLIP)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.FALSE)
	c:RegisterEffect(e1)
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(69696916,0))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e2:SetCondition(c69696916.con)
	e2:SetTarget(c69696916.drtg)
	e2:SetOperation(c69696916.drop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_FLIP)
	c:RegisterEffect(e3)
	--handes
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(69696916,1))
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e4:SetCode(EVENT_SUMMON_SUCCESS)
	e4:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e4:SetCondition(c69696916.con)
	e4:SetTarget(c69696916.hdtg)
	e4:SetOperation(c69696916.hdop)
	c:RegisterEffect(e4)
	local e3=e4:Clone()
	e3:SetCode(EVENT_FLIP)
	c:RegisterEffect(e3)
end
function c69696916.con(e,tp,eg,ep,ev,re,r,rp)
	local th=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)  
	local thp=Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)  
	return thp>th
end
function c69696916.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local th=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)  
	local thp=Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)
	local ct=thp-th
	if chk==0 then return ct>0 and Duel.IsPlayerCanDraw(tp,ct) end
	Duel.SetTargetPlayer(tp)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,ct)
end
function c69696916.drop(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local th=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)  
	local thp=Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)
	local ct=thp-th
	if ct>0 then
		Duel.Draw(p,ct,REASON_EFFECT)
	end
end
function c69696916.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local th=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)  
	local thp=Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)
	local ct=thp-th
	if chk==0 then return ct>0 and Duel.IsPlayerCanDraw(tp,ct) end
	Duel.SetTargetPlayer(tp)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,ct)
end
function c69696916.drop(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local th=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)  
	local thp=Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)
	local ct=thp-th
	if ct>0 then
		Duel.Draw(p,ct,REASON_EFFECT)
	end
end
function c69696916.hdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local th=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)  
	local thp=Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)
	local ct=thp-th
	if chk==0 then return ct>0 end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,1-tp,ct)
end
function c69696916.hdop(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local th=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)  
	local thp=Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)
	local ct=thp-th
	local g=Duel.GetFieldGroup(p,LOCATION_HAND,0)
	if ct>0 then
		Duel.Hint(HINT_SELECTMSG,p,HINTMSG_DISCARD)
		local sg=g:FilterSelect(p,Card.IsDiscardable,ct,ct,nil,p)
		Duel.SendtoGrave(sg,REASON_EFFECT+REASON_DISCARD)
	end
end

