--尾升机小狐
if not pcall(function() require("expansions/script/c33331100") end) then require("script/c33331100") end
local m=33331101
local cm=_G["c"..m]
function cm.initial_effect(c)
	rslf.SpecialSummonFunction(c,m,cm.con,cm.op,cm.buff)
end
function cm.con(e,tp)
	return Duel.CheckReleaseGroup(tp,Card.IsSetCard,1,nil,0x2553)
end
function cm.op(e,tp)
	local g=Duel.SelectReleaseGroup(tp,Card.IsSetCard,1,1,nil,0x2553)
	Duel.Release(g,REASON_COST)
end
function cm.buff(c)
	local e1=rsef.SV_IMMUNE_EFFECT(c,cm.efilter)
	local e2=rsef.I(c,{m,0},nil,"tg,sp",nil,LOCATION_MZONE,cm.lcon,nil,cm.ltg,cm.lop)
	return e1,e2
end
function cm.efilter(e,te)
	return te:GetOwnerPlayer()~=e:GetHandlerPlayer() and te:IsActiveType(TYPE_MONSTER)
end
function cm.lcon(e,tp)
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)<Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)
end
function cm.cfilter(c,e,tp)
	return c:IsAbleToGrave() and c:IsFaceup() and c:IsSetCard(0x2553) and Duel.IsExistingMatchingCard(cm.cfilter2,tp,0,LOCATION_MZONE,1,nil,e,tp,c)
end
function cm.cfilter2(c,e,tp,rc)
	local g=Group.FromCards(c,rc)
	return c:IsAbleToGrave() and c:IsFaceup() and Duel.GetLocationCountFromEx(tp,tp,g)>0 and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_EXTRA,0,1,nil,g,e,tp)
end
function cm.spfilter(c,g,e,tp)
	return c:IsType(TYPE_LINK) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_LINK,tp,false,false) and (not g or g:FilterCount(Card.IsCanBeLinkMaterial,nil,c)==2) and c:IsSetCard(0x2553) and c:GetLink()==2
end
function cm.ltg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,2,PLAYER_ALL,LOCATION_MZONE)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function cm.lop(e,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g1=Duel.SelectMatchingCard(tp,cm.cfilter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	if #g1<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g2=Duel.SelectMatchingCard(tp,cm.cfilter2,tp,0,LOCATION_MZONE,1,1,nil,e,tp,g1:GetFirst())
	g1:Merge(g2)
	Duel.HintSelection(g1)
	if Duel.SendtoGrave(g1,REASON_EFFECT+REASON_MATERIAL+REASON_LINK)~=0 and Duel.GetLocationCountFromEx(tp)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tc=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,nil,e,tp):GetFirst()
		tc:SetMaterial(g1)
		rssf.SpecialSummon(tc,SUMMON_TYPE_LINK)
	end
end
