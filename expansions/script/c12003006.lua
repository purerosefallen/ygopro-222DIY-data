--水歌 圆奏龙爱迷尔
local m=12003006
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE+LOCATION_HAND)
	e2:SetCost(cm.spcost)
	e2:SetTarget(cm.sptg)
	e2:SetOperation(cm.spop)
	c:RegisterEffect(e2)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,2))
	e4:SetCategory(CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(0x14000)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetCondition(cm.descon)
	e4:SetTarget(cm.destg)
	e4:SetOperation(cm.desop)
	c:RegisterEffect(e4)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,12003006)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCost(function(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return Duel.CheckReleaseGroup(tp,cm.cfilter1,1,nil,tp) and Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK,0,1,nil) end
		local g1=Duel.SelectReleaseGroup(tp,cm.cfilter1,1,1,nil,tp)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_DECK,0,1,1,nil)
		Duel.Release(g1,REASON_COST)
		Duel.SendtoGrave(g,REASON_COST)
	end)
	e2:SetTarget(function(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return true end
	end)
	e2:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetCountLimit(1)
		e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
			return Duel.IsExistingMatchingCard(function(c) return c:IsRace(RACE_SEASERPENT) and c:IsAbleToDeck() end,tp,LOCATION_GRAVE,0,3,nil)
		end)
		e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
			local g=Duel.SelectMatchingCard(tp,function(c) return c:IsRace(RACE_SEASERPENT) and c:IsAbleToDeck() end,tp,LOCATION_GRAVE,0,1,3,nil)
			Duel.SendtoDeck(g,nil,0,REASON_EFFECT)
			local og=Duel.GetOperatedGroup()
			for _,p in ipairs({tp,1-tp}) do
				if og:IsExists(function(c) return c:IsLocation(LOCATION_DECK) and c:IsControler(p) end,1,nil) then
					Duel.ShuffleDeck(p)
				end
			end
		end)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	end)
	c:RegisterEffect(e2)
end
function cm.CheckFieldFilter(g,tp,c,f,...)
	if c:IsLocation(LOCATION_EXTRA) then
		return Duel.GetLocationCountFromEx(tp,tp,g,c)>0 and (not f or f(g,...))
	else
		return Duel.GetMZoneCount(tp,g,tp)>0 and (not f or f(g,...))
	end
end
function cm.CheckGroupRecursive(c,sg,g,f,min,max,ext_params)
	sg:AddCard(c)
	local ct=sg:GetCount()
	local res=(ct>=min and ct<=max and f(sg,table.unpack(ext_params)))
		or (ct<max and g:IsExists(cm.CheckGroupRecursive,1,sg,sg,g,f,min,max,ext_params))
	sg:RemoveCard(c)
	return res
end
function cm.CheckGroup(g,f,cg,min,max,...)
	local min=min or 1
	local max=max or g:GetCount()
	if min>max then return false end
	local ext_params={...}
	local sg=Group.CreateGroup()
	if cg then sg:Merge(cg) end
	local ct=sg:GetCount()
	if ct>=min and ct<=max and f(sg,...) then return true end
	return g:IsExists(cm.CheckGroupRecursive,1,sg,sg,g,f,min,max,ext_params)
end
function cm.SelectGroup(tp,desc,g,f,cg,min,max,...)
	local min=min or 1
	local max=max or g:GetCount()
	local ext_params={...}
	local sg=Group.CreateGroup()
	local cg=cg or Group.CreateGroup()
	sg:Merge(cg)
	local ct=sg:GetCount()
	local ag=g:Filter(cm.CheckGroupRecursive,sg,sg,g,f,min,max,ext_params)  
	while ct<max and ag:GetCount()>0 do
		local finish=(ct>=min and ct<=max and f(sg,...))
		local seg=sg:Clone()
		local dmin=min-cg:GetCount()
		local dmax=math.min(max-cg:GetCount(),g:GetCount())
		seg:Sub(cg)
		Duel.Hint(HINT_SELECTMSG,tp,desc)
		local tc=ag:SelectUnselect(seg,tp,finish,finish,dmin,dmax)
		if not tc then break end
		if sg:IsContains(tc) then
			sg:RemoveCard(tc)
		else
			sg:AddCard(tc)
		end
		ct=sg:GetCount()
		ag=g:Filter(cm.CheckGroupRecursive,sg,sg,g,f,min,max,ext_params)
	end
	return sg
end
function cm.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local mg=Duel.GetMatchingGroup(function(c) return c:IsRace(RACE_SEASERPENT) and c:IsReleasable() and c:IsLevelBelow(4) end,tp,LOCATION_HAND+LOCATION_MZONE,0,c)
	if chk==0 then return cm.CheckGroup(mg,cm.CheckFieldFilter,nil,2,63,tp,c) end
	local sg=cm.SelectGroup(tp,HINTMSG_RELEASE,mg,cm.CheckFieldFilter,nil,2,63,tp,c)
	if sg:IsExists(Card.IsOnField,3,nil) then
		e:SetLabel(1)
	else
		e:SetLabel(0)
	end
	Duel.Release(sg,REASON_COST)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummonStep(c,0,tp,tp,false,false,POS_FACEUP) then
		if e:GetLabel()==1 then
			c:RegisterFlagEffect(m,0x1fe1000,0,1)
		end
		Duel.SpecialSummonComplete()
	end
end
function cm.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(m)>0
end
function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local sg=Duel.GetMatchingGroup(Card.IsAbleToHand,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
	Duel.SetChainLimit(function(e,ep,tp)
		return tp==ep
	end)
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(Card.IsAbleToHand,tp,0,LOCATION_MZONE,nil)
	Duel.SendtoHand(sg,nil,REASON_EFFECT)
end
function cm.cfilter1(c,tp)
	return c:IsRace(RACE_SEASERPENT)
end
function cm.filter(c)
	return c:IsRace(RACE_SEASERPENT) and c:IsAbleToGraveAsCost()
end
