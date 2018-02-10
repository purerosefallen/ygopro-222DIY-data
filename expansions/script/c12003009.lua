--水歌 零奏龙米提
local m=12003009
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetRange(LOCATION_HAND)
	e1:SetProperty(0x14000)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetCountLimit(1,12003109)
	e1:SetCondition(cm.spcon)
	e1:SetTarget(cm.sptg)
	e1:SetOperation(cm.spop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,12003009)
	e2:SetCost(function(e,tp,eg,ep,ev,re,r,rp,chk)
		local mg=Duel.GetMatchingGroup(Card.IsAbleToDeckAsCost,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil)
		if chk==0 then return cm.CheckGroup(mg,function(g) return g:GetClassCount(Card.GetCode)==1 end,nil,2,63) end
		local g=cm.SelectGroup(tp,HINTMSG_TODECK,mg,function(g) return g:GetClassCount(Card.GetCode)==1 end,nil,2,63)
		if g:GetCount()==3 then
			e:SetLabel(1)
		else
			e:SetLabel(0)
		end
		Duel.SendtoDeck(g,nil,2,REASON_COST)
	end)
	e2:SetTarget(function(e,tp,eg,ep,ev,re,r,rp,chk)
		local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_EXTRA,nil)
		if chk==0 then return g:GetCount()>0 end
	end)
	e2:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_EXTRA,nil)
		if g:GetCount()==0 then return end
		Duel.ConfirmCards(tp,g)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local gc=g:Select(tp,1,1,nil):GetFirst()
		local code=gc:GetCode()
		Duel.Remove(gc,POS_FACEDOWN,REASON_EFFECT)
		if e:GetLabel()==1 then
			g:RemoveCard(gc)
			local exg=g:Filter(Card.IsCode,nil,code)
			if exg:GetCount()>0 then
				Duel.BreakEffect()
				Duel.Remove(exg,POS_FACEDOWN,REASON_EFFECT)
			end
		end
	end)
	c:RegisterEffect(e2)
end
function cm.CheckGroupRecursive(c,sg,g,f,min,max,ext_params)
	sg:AddCard(c)
	local ct=sg:GetCount()
	local res=(ct>=min and ct<=max and f(sg,table.unpack(ext_params)))
		or (ct<max and f(sg,table.unpack(ext_params)) and g:IsExists(cm.CheckGroupRecursive,1,sg,sg,g,f,min,max,ext_params))
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
function cm.gfilter(c,tp)
	return c:IsReason(REASON_COST) and (c:GetPreviousRaceOnField() & RACE_SEASERPENT~=0 and c:IsPreviousLocation(LOCATION_ONFIELD) or c:IsRace(RACE_SEASERPENT) and not c:IsPreviousLocation(LOCATION_ONFIELD))
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.gfilter,1,nil,tp) and re and re:IsHasType(0x7e0)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMZoneCount(tp)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end
