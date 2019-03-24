--龙棋兵团 军团长
if not pcall(function() require("expansions/script/c18006001") end) then require("script/c18006001") end
local m=18006006
local cm=_G["c"..m]
cm.rssetcode="DragonChessCorps"
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,cm.lfilter,2)
	local e1=rsef.FTF(c,EVENT_PHASE+PHASE_END,{m,0},1,"des",nil,LOCATION_MZONE,cm.con(0,true),nil,cm.tg,cm.op)
	local e2=rsef.SV_UPDATE(c,"atk",1000,cm.con(1))
	local e3=rsef.SV_IMMUNE_EFFECT(c,cm.val,cm.con(2))
	local e4=rsef.QO(c,nil,{m,1},1,"th,des","tg",LOCATION_MZONE,cm.con(3),nil,rstg.target({cm.thfilter,"th",LOCATION_ONFIELD },rsop.list(aux.TRUE,"des",0,LOCATION_ONFIELD )),cm.thop)
end
function cm.thfilter(c)
	return c:IsAbleToHand() and rsdcc.IsSet(c) and c:IsFaceup()
end
function cm.thop(e,tp)
	local tc=rscf.GetTargetCard()
	if tc and Duel.SendtoHand(tc,nil,REASON_EFFECT)>0 and tc:IsLocation(LOCATION_HAND) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local dg=Duel.SelectMatchingCard(tp,nil,tp,0,LOCATION_ONFIELD,1,1,nil)
		if #dg>0 then
			Duel.HintSelection(dg)
			Duel.Destroy(dg,REASON_EFFECT)
		end
	end
end
function cm.imfilter(c,rc)
	return rc:IsOnField() and c:GetColumnGroup():IsContains(rc)
end
function cm.val(e,re)
	local c=e:GetHandler()
	local rc=re:GetHandler()
	local g=Duel.GetMatchingGroup(cm.cfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	if #g<=0 then return false end
	return not (g:IsExists(cm.imfilter,1,nil,rc) and rsdcc.IsSet(rc))
end
function cm.cfilter(c)
	return rsdcc.IsSet(c) and c:IsFaceup() 
end
function cm.lfilter(c)
	return c:CheckLinkSetCard("DragonChessCorps") and c:IsType(TYPE_EFFECT)
end
function cm.seqfilter(c,seqlist)
	return rsdcc.IsSet(c) and c:IsFaceup() and rsof.Table_List(seqlist,c:GetSequence())
end
function cm.con(ct,bool)
	return function(e)
		local c=e:GetHandler()
		if not c:IsType(TYPE_LINK) then return false end
		local zone=c:GetLinkedZone(tp)
		local seqlist={}
		if zone<=0 then return end
		local list1={1,2,4,8,16,32,64}
		local list2={0,1,2,3,4,5,6}
		for k,azone in pairs(list1) do
			if zone&azone~=0 then
				table.insert(seqlist,1)
			end
		end
		local cg=Duel.GetMatchingGroup(cm.seqfilter,tp,LOCATION_ONFIELD,0,nil,seqlist)
		if bool then
			return cg==ct
		else
			return cg>=ct
		end
	end
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
end
function cm.setfilter(c)
	return c:IsSSetable() and rsdcc.filter(c)
end
function cm.op(e,tp)
	local c=aux.ExceptThisCard(e)
	if not c or Duel.Destroy(c,REASON_EFFECT)<=0 or Duel.GetLocationCount(tp,LOCATION_SZONE)<2 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,cm.setfilter,tp,LOCATION_DECK,0,2,2,nil)
	if #g==2 then
		Duel.SSet(tp,g)
		Duel.ConfirmCards(1-tp,g)
	end
end