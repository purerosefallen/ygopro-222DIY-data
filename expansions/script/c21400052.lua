--露文律的牦牛尾
--script by Real_Scl
local m=21400052
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)  
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e2:SetDescription(aux.Stringid(m,2))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1,2149052)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetTarget(cm.tdtg)
	e2:SetOperation(cm.tdop)
	c:RegisterEffect(e2)  
end

function cm.spfilter(c,e,tp,mc,rg0)
	return bit.band(c:GetOriginalType(),0x81)==0x81 and (not c.mat_filter or c.mat_filter(mc) or (rg0 and rg0:IsContains(c)))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true)
		and (mc:IsCanBeRitualMaterial(c) or (rg0 and rg0:IsContains(c))) and (c:IsLocation(LOCATION_HAND) or c:IsFaceup()) and ((c:IsLocation(LOCATION_EXTRA) and Duel.GetLocationCountFromEx(tp,tp,mc)>0) or (not c:IsLocation(LOCATION_EXTRA) and Duel.GetMZoneCount(tp,mc,tp)>0)) and cm.lvfilter(c)>0 and c:IsSetCard(0xc21)
end
function cm.lvfilter(c)
	local lv=c:GetLevel()
	if not c:IsLocation(LOCATION_HAND) then
	   lv=c:GetOriginalLevel()
	end
	return lv
end
function cm.rfilter(c,mc,notbool)
	local lv=cm.lvfilter(c)
	local mlv=mc:GetRitualLevel(c)
	local lv=c:GetLevel()
	return lv==bit.band(mlv,0xffff) or lv==bit.rshift(mlv,16) or (mc:IsLevelAbove(lv) and notbool==false)
end
function cm.filter(c,e,tp)
	local sg1=Duel.GetMatchingGroup(cm.spfilter,tp,LOCATION_HAND+LOCATION_PZONE+LOCATION_EXTRA,0,c,e,tp,c)
	return sg1:IsExists(cm.rfilter,1,nil,c,false)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local mg=Duel.GetRitualMaterial(tp)
	if chk==0 then return mg:IsExists(cm.filter,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_PZONE+LOCATION_EXTRA)
end
function cm.rfilter2(c,sg,mlv)
	local lv1=sg:GetSum(cm.lvfilter)
	local lv2=cm.lvfilter(c)
	return lv1+lv2<=mlv
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local mg=Duel.GetRitualMaterial(tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local mat=mg:FilterSelect(tp,cm.filter,1,1,nil,e,tp)
	local mc=mat:GetFirst()
	if not mc then return end
	local sg=Group.CreateGroup()
	local rg0=Duel.GetMatchingGroup(cm.spfilter,tp,LOCATION_HAND+LOCATION_PZONE+LOCATION_EXTRA,0,mc,e,tp,mc)
	local tf=false 
	repeat
		local rg=Duel.GetMatchingGroup(cm.spfilter,tp,LOCATION_HAND+LOCATION_PZONE+LOCATION_EXTRA,0,mc,e,tp,mc,rg0)
		if rg:GetCount()<=0 then break end
		local tc=nil
		if sg:GetCount()<=0 then
		   Duel.ReleaseRitualMaterial(mat)
		   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		   tc=rg:Select(tp,1,1,nil):GetFirst()
		   if cm.rfilter(tc,mc,true) and (not cm.rfilter2(tc,sg,mc:GetLevel()) or Duel.SelectYesNo(tp,aux.Stringid(m,0))) then tf=true end
		else
		   if Duel.IsPlayerAffectedByEffect(tp,59822133) then break end
		   local sg2=rg:Filter(cm.rfilter2,nil,sg,mc:GetLevel()) 
		   if sg2:GetCount()<=0 then break end
		   if sg:GetCount()>0 and not Duel.SelectYesNo(tp,aux.Stringid(m,1)) then break end
		   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		   tc=sg2:Select(tp,1,1,nil):GetFirst()
		end
		if sg:GetCount()==1 then
		   Duel.BreakEffect()
		end
		Duel.SpecialSummonStep(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
		sg:AddCard(tc)
	until tf
	if sg:GetCount()>0 then
	   for tc in aux.Next(sg) do
		   tc:SetMaterial(mat)
		   tc:CompleteProcedure()
	   end
	   Duel.SpecialSummonComplete()
	end
end
function cm.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeck() and Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function cm.tdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SendtoDeck(c,nil,0,REASON_EFFECT)~=0 and c:IsLocation(LOCATION_DECK) then
		Duel.ShuffleDeck(tp)
		Duel.BreakEffect()
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end
--bug report QQ 2798419987