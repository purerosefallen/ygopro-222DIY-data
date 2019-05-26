--芬芳花嫁·高森蓝子
function c81009032.initial_effect(c)
	c:EnableReviveLimit()
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c81009032.spcon)
	e1:SetOperation(c81009032.spop)
	c:RegisterEffect(e1)
	--splimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(1,0)
	e2:SetTarget(c81009032.splimit)
	c:RegisterEffect(e2)
	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOEXTRA+CATEGORY_REMOVE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,10678779)
	e3:SetCost(c81009032.descost)
	e3:SetTarget(c81009032.destg)
	e3:SetOperation(c81009032.desop)
	c:RegisterEffect(e3)
end
function c81009032.spcostfilter(c)
	return c:IsAbleToRemoveAsCost() and (c:IsType(TYPE_SYNCHRO) or c:IsType(TYPE_FUSION))
end
function c81009032.spcost_selector(c,tp,g,sg,i)
	sg:AddCard(c)
	g:RemoveCard(c)
	local flag=false
	if i<2 then
		flag=g:IsExists(c81009032.spcost_selector,1,nil,tp,g,sg,i+1)
	else
		flag=sg:FilterCount(Card.IsType,nil,TYPE_SYNCHRO)>0
			and sg:FilterCount(Card.IsType,nil,TYPE_FUSION)>0
	end
	sg:RemoveCard(c)
	g:AddCard(c)
	return flag
end
function c81009032.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	if Duel.GetMZoneCount(tp)<=0 then return false end
	local g=Duel.GetMatchingGroup(c81009032.spcostfilter,tp,LOCATION_EXTRA,0,nil)
	local sg=Group.CreateGroup()
	return g:IsExists(c81009032.spcost_selector,1,nil,tp,g,sg,1)
end
function c81009032.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetMatchingGroup(c81009032.spcostfilter,tp,LOCATION_EXTRA,0,nil)
	local sg=Group.CreateGroup()
	for i=1,2 do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g1=g:FilterSelect(tp,c81009032.spcost_selector,1,1,nil,tp,g,sg,i)
		sg:Merge(g1)
		g:Sub(g1)
	end
	Duel.Remove(sg,POS_FACEUP,REASON_COST)
end
function c81009032.splimit(e,c,sump,sumtype,sumpos,targetp)
	return c:IsType(TYPE_LINK) or c:IsType(TYPE_XYZ)
end
function c81009032.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c81009032.filter(c,tp)
	local ctype=bit.band(c:GetType(),TYPE_FUSION+TYPE_SYNCHRO)
	return c:IsFaceup() and ctype~=0 and c:IsAbleToExtra()
		and Duel.IsExistingMatchingCard(c81009032.filter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,ctype)
end
function c81009032.filter2(c,ctype)
	return c:IsFaceup() and c:IsType(ctype) and c:IsAbleToRemove()
end
function c81009032.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and chkc:IsControler(tp) and c81009032.filter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(c81009032.filter,tp,LOCATION_REMOVED,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c81009032.filter,tp,LOCATION_REMOVED,0,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,g,1,0,0)
	local ctype=bit.band(g:GetFirst():GetType(),TYPE_FUSION+TYPE_SYNCHRO)
	local dg=Duel.GetMatchingGroup(c81009032.filter2,tp,LOCATION_MZONE,LOCATION_MZONE,nil,ctype)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,dg,1,0,0)
end
function c81009032.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SendtoDeck(tc,nil,0,REASON_EFFECT)~=0 then
		local ctype=bit.band(tc:GetType(),TYPE_FUSION+TYPE_SYNCHRO)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=Duel.SelectMatchingCard(tp,c81009032.filter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,ctype)
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
end
