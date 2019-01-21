--小黄
if not pcall(function() require("expansions/script/c10199990") end) then require("script/c10199990") end
local m=12030005
local cm=_G["c"..m]
cm.rssetcode="yatori"
function cm.initial_effect(c)
	local e1=rsef.QO(c,nil,{m,0},nil,"sp",nil,LOCATION_HAND,nil,cm.spcost,cm.sptg,cm.spop)
	local e2=rsef.STO(c,EVENT_SPSUMMON_SUCCESS,{m,1},nil,"sp","tg,de",nil,nil,rstg.target({cm.cfilter,nil,LOCATION_MZONE,LOCATION_MZONE }),cm.lvop)
	local e3=rsef.STO(c,EVENT_TO_GRAVE,{m,3},nil,"con","tg,de",cm.ctcon,nil,rstg.target({cm.ctfilter,nil,0,LOCATION_MZONE }),cm.ctop)
end
function cm.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return (c:GetFlagEffect(m)==0 or Duel.GetTurnPlayer()~=tp) and Duel.CheckReleaseGroup(tp,rscf.CheckSetCard,1,nil,"yatori")  end
	local g=Duel.SelectReleaseGroup(tp,rscf.CheckSetCard,1,1,nil,"yatori")
	Duel.Release(g,REASON_COST)
	c:RegisterFlagEffect(m,rsreset.est_pend,0,1)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end
function cm.cfilter(c,e)
	return (c:IsLevelAbove(1) or c:IsRankAbove(1)) and c:IsFaceup() and not c:IsLevel(e:GetHandler():GetLevel())
end
function cm.lvop(e,tp)
	local c=aux.ExceptThisCard(e)
	local tc=rscf.GetTargetCard(Card.IsFaceup)
	if not c or not tc then return end
	local lv=0
	if tc:IsLevelAbove(1) then lv=tc:GetLevel()
	else lv=tc:GetRank()
	end
	local e1=rsef.SV_CHANGE(c,"lv",lv,nil,rsreset.est+RESET_DISABLE)
	local g=Duel.GetMatchingGroup(Card.IsSynchroSummonable,tp,LOCATION_EXTRA,0,nil,nil)
	if #g>0 and Duel.SelectYesNo(tp,aux.Stringid(m,2)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,1,1,nil)
		Duel.SynchroSummon(tp,sg:GetFirst(),nil)
	end
end
function cm.ctcon(e,tp)
	local c=e:GetHandler()
	if not c:IsReason(REASON_EFFECT) then return false end
	e:SetLabel(0)
	if c:GetReasonPlayer()~=tp then e:SetLabel(1) end
	return true
end
function cm.ctfilter(c,e)
	local op=e:GetLabel()   
	return c:IsFaceup() and (op==0 or c:IsControlerCanBeChanged())
end
function cm.ctop(e,tp)
	local c=e:GetHandler()
	local tc=rscf.GetTargetCard()
	if not tc then return end
	local e1=rsef.SV_ADD({c,tc},"set","yatori",nil,rsreset.est)
	Duel.GetControl(tc,tp)
end
